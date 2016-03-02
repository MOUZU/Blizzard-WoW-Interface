
-- List of spell ID's to check... feel free to modify this list at will.
QATest_CombatSpells = {
	701, 686
};
QATest_NormalSpells = {
	688,
};

-- Variables to tune the test
TestSpell_CombatDummy = 1921;

-- Steps to automatically test a spell
TestSpell_CombatSteps = {
	function(id)
		QATest_Print("Learning spell #"..id);
		QATest_Exec("learn "..id);
		QATest_Delay(1);
	end,
	TestUnit_Steps[1],
	TestUnit_Steps[2],
	function()
		TestUnit_Steps[3](TestSpell_CombatDummy);
	end,
	TestUnit_Steps[4],
	TestUnit_Steps[5],
	TestUnit_Steps[6],
	function(id)
		CastSpellID(id);
	end,
	TestUnit_Steps[7],
	TestUnit_Steps[8],
};
TestSpell_NormalSteps = {
	function(id)
		QATest_Print("Learning spell #"..id);
		QATest_Exec("learn "..id);
		QATest_Delay(1);
	end,
	function(id)
		CastSpellID(id);
	end,
	function()
		QATest_Print("Hit any key to continue test...");
		QATest_Wait();
	end,
};

QAMenu_Tests[QATest_Index] = {
	label = "Combat Spell Test",
	arg_start = 1,
	arg_limit = getn(QATest_CombatSpells),
	arg_table = QATest_CombatSpells,
	steps = TestSpell_CombatSteps
};
QATest_Index = QATest_Index + 1;

QAMenu_Tests[QATest_Index] = {
	label = "Normal Spell Test",
	arg_start = 1,
	arg_limit = getn(QATest_NormalSpells),
	arg_table = QATest_NormalSpells,
	steps = TestSpell_NormalSteps
};
QATest_Index = QATest_Index + 1;
