
-- Uncomment the next line to get information at each step of a test
--QATEST_VERBOSE = 1;

--
-- The list of available tests (a maximum of 23 tests at any one time)
--
QAMenu_Tests = { };

-- This index is used to dynamically register tests from other files
QATest_Index = 1;

--
-- Script code for actually running the tests
--
QATest = nil;

function QATest_StartTest(index)
	if ( QATest.test ) then
		message("Warning, interrupting test in progress");
	end
	local test = QAMenu_Tests[index];
	QATest.test = test;
	QATest.step = 0;
	QATest.delay = 0;
	QATest.wait = nil;
	QATest.arg = test.arg_start;
	QATest_Print("Starting "..test.label);
end

function QATest_Print(text)
	SendChatMessage(text, ChatFrameEditBox.chatType, ChatFrameEditBox.language);
end

function QATest_Delay(delay)
	QATest.delay = delay;
end

function QATest_Wait()
	QATest:EnableKeyboard(1);
	QATest.wait = 1;
end

function QATest_WaitEnded()
	QATest.wait = nil;
	QATest:EnableKeyboard(0);
end

function QATest_NextStep(step)
	local test = QATest.test;
	step = step + 1;
	QATest.step = step;
	if ( not test.steps[step] ) then
		QATest_LoopTest();
		if ( QATest.test ) then
			QATest_NextStep(0);
		end
	end
end

function QATest_LoopTest()
	local test = QATest.test;
	if ( test.arg_limit ) then
		if ( QATest.arg < test.arg_limit ) then
			QATest.arg = QATest.arg + 1;
			QATest.step = 0;
			return;
		end
	end
	QATest_StopTest();
end

function QATest_StopTest()
	if ( QATEST_VERBOSE ) then
		QATest_Print("Finished "..QATest.test.label);
	end
	QATest.test = nil;
	QATest_WaitEnded();
	QATest_Print("Test complete.");
end

function QAMenuButton_OnClick()
	QATest_StartTest(this:GetID());
end

function QAMenu_OnLoad()
	QATest = QAMicroButton;
	QATest.test = nil;

	UIMenu_Initialize();
	local index = 1;
	while ( QAMenu_Tests[index] ) do
		UIMenu_AddButton(QAMenu_Tests[index].label, nil, QAMenuButton_OnClick);
		index = index + 1;
	end
end

function QAMenu_OnShow()
	UIMenu_OnShow();
end

function QAMenu_OnUpdate(elapsed)
	-- Don't do anything if there are no tests active
	if ( not this.test or this.wait ) then
		return;
	end

	-- See if we're currently delaying for a bit
	if ( this.delay > 0 ) then
		this.delay = this.delay - elapsed;
		if ( this.delay > 0 ) then
			return;
		end
	end

	-- Move on to the next step
	QATest_NextStep(this.step);
	if ( not this.test ) then
		return;
	end

	-- Execute the current step
	local test = this.test;
	local step = this.step;
	local func = test.steps[step];
	local arg = test["arg"..step];
	if ( not arg ) then
		if ( test.arg_table ) then
			arg = test.arg_table[this.arg];
		else
			arg = this.arg;
		end
	end
	if ( QATEST_VERBOSE ) then
		QATest_Print("Executing "..test.label.." step "..step);
	end
	func(arg);
end