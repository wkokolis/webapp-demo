import pytest
from demo import Demo

def test_stat_mod():
  demo = Demo()
  mystat = 15
  assert demo.stat_mod(mystat) == 2
  mystat = 20
  assert demo.stat_mod(mystat) == 5
  mystat = 9
  assert demo.stat_mod(mystat) == -1
  mystat = 6
  assert demo.stat_mod(mystat) == -2
  mystat = 0
  assert demo.stat_mod(mystat) == -5

def test_roll_stats():
  demo = Demo()
  count = 2
  assert len(demo.roll_stats(count)) == 2

def test_statistic():
  demo = Demo()
  thisstat = demo.statistic()
  assert (3 <= thisstat <= 18)
  thisstat = demo.statistic()
  assert (3 <= thisstat <= 18)
  thisstat = demo.statistic()
  assert (3 <= thisstat <= 18)

def test_get_mods():
  demo = Demo()
  numstats = 6
  stats_out = demo.get_mods()
  assert len(stats_out) == 6

  stat_list = ["Strength", "Constitution", "Dexterity", "Intelligence", "Wisdom", "Charisma"]
  for x in stat_list:
    assert len(stats_out[x]) == 2
    thisvalue = stats_out[x]["value"]
    assert (3 <= thisvalue <= 18)
