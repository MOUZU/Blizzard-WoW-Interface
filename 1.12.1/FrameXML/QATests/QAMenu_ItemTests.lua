
-- List of item ID's to check... feel free to modify this list at will.
QATest_CombatItems = {
	2046, 2049
};
QATest_NormalItems = {
	1164,
};

-- Variables to tune the test
TestItem_CombatDummy = 1921;
TestItem_EquipItem = 1;
TestItem_UseItem = 1;

-- Steps to automatically test an item
TestItem_CombatSteps = {
	function()
		CharacterFrame:Show();
		PaperDollFrame:Show();
		OpenBackpack();
	end,
	function(id)
		QATest_Print("Creating item #"..id);
		QATest_Exec("ci "..id);
		QATest_Delay(1);
	end,
	function(id)
		if ( TestItem_EquipItem ) then
			EquipItemID(id);
		end
		if ( TestItem_UseItem ) then
			UseItemID(id);
		end
	end,
	TestUnit_Steps[1],
	TestUnit_Steps[2],
	function()
		TestUnit_Steps[3](TestItem_CombatDummy);
	end,
	TestUnit_Steps[4],
	TestUnit_Steps[5],
	TestUnit_Steps[6],
	TestUnit_Steps[7],
	TestUnit_Steps[8],
	function(id)
		DeleteItemID(id);
	end,
};
TestItem_NormalSteps = {
	function()
		CharacterFrame:Show();
		PaperDollFrame:Show();
		OpenBackpack();
	end,
	function(id)
		QATest_Print("Creating item #"..id);
		QATest_Exec("ci "..id);
		QATest_Delay(1);
	end,
	function(id)
		if ( TestItem_EquipItem ) then
			EquipItemID(id);
		end
		if ( TestItem_UseItem ) then
			UseItemID(id);
		end
	end,
	function()
		QATest_Print("Hit any key to continue test...");
		QATest_Wait();
	end,
	function(id)
		DeleteItemID(id);
	end,
};

QAMenu_Tests[QATest_Index] = {
	label = "Combat Item Test",
	arg_start = 1,
	arg_limit = getn(QATest_CombatItems),
	arg_table = QATest_CombatItems,
	steps = TestItem_CombatSteps
};
QATest_Index = QATest_Index + 1;

QAMenu_Tests[QATest_Index] = {
	label = "Normal Item Test",
	arg_start = 1,
	arg_limit = getn(QATest_NormalItems),
	arg_table = QATest_NormalItems,
	steps = TestItem_NormalSteps
};
QATest_Index = QATest_Index + 1;
