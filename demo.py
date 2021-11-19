import logging, operator, random

class Demo:
  def __init__(self):

    self.stat_list = ["Strength", "Constitution", "Dexterity", "Intelligence", "Wisdom", "Charisma"]
    self.stat_mods = {}

  def roll_stats(self, count):
    """
      This creates our statistic list.  We create eight random numbers by
      invoking the statistic method.
    """
    all_stats = []

    for x in range(count):
      stat = self.statistic()
      all_stats.append(stat)

    return all_stats

  def statistic(self):
    """
      Generate four random numbers from 1-6, drop the lowest, and sum them.
    """
    first = random.randint(1, 6)
    second = random.randint(1, 6)
    third = random.randint(1, 6)
    forth = random.randint(1, 6)

    x = min(first,second,third,forth)

    roll = first + second + third + forth - x

    return roll

  def stat_mod(self, statistic):
    """
      Determine the stat modifier.  Use integer division to halve the
      statistic and then subtract five from the result.

      stat 10 = mod 0
      stat 20 = mod 5
    """
    # Preferable to calculate this way since there are multiple ways to handle modulo division around 0 
    modifier = (statistic // 2) - 5

    return modifier

  def get_mods(self):
    full_stats = {}
    statistics = self.roll_stats(6)

    i = 0
    while i < 6:
      thismod = self.stat_mod(statistics[i])
      full_stats[self.stat_list[i]] = {"value": statistics[i], "modifier": thismod}
      i += 1

    return full_stats
