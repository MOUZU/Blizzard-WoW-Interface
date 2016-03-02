
-- List of unit ID's to check... feel free to modify this list at will.
QATest_Units = {
	707, 724,
};

-- Variables to tune the test
TestUnit_UnitLocation = "-576 104 55 270";
TestUnit_SafeLocation = "-576 101 55 90";

-- Steps to automatically fight a monster
-- WARNING: The item and spell tests reference these steps!!!
TestUnit_Steps = {
	function()
		QATest_Exec("beastmaster on");
	end,
	function()
		QATest_Exec("port "..TestUnit_UnitLocation);
		QATest_Delay(1);
	end,
	function(id)
		QATest_Print("Creating creature #"..id);
		QATest_Exec("cm "..id);
	end,
	function()
		QATest_Exec("port "..TestUnit_SafeLocation);
		QATest_Delay(1);
	end,
	function()
		QATest_Exec("godmode 1");
		QATest_Exec("beastmaster off");
	end,
	function()
		ActionButtonDown(0);
		ActionButtonUp(0);
	end,
	function()
		QATest_Print("Hit any key to continue test...");
		QATest_Wait();
	end,
	function()
		DeleteTargetUnit();
		QATest_Exec("godmode 0");
	end,
};

QAMenu_Tests[QATest_Index] = {
	label = "Unit Test",
	arg_start = 1,
	arg_limit = getn(QATest_Units),
	arg_table = QATest_Units,
	steps = TestUnit_Steps
};
QATest_Index = QATest_Index + 1;
