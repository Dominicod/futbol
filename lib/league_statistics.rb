require_relative 'nameable'
class LeagueStatistics
  include Nameable
  def initialize(data)
    @data = data
  end

  def count_of_teams
    team_id_array = []
    @data[:game_teams].each do |row|
      team_id_array << row[1]
    end
    team_id_array.uniq.count
  end

  def best_offense
    best_team = team_goal_stats_averages.max_by { |_team, average| average }
    Nameable.return_team_name(best_team[0], @data)
  end

  def worst_offense
    worst_team = team_goal_stats_averages.min_by { |_team, average| average }
    Nameable.return_team_name(worst_team[0], @data)
  end

  def highest_scoring_visitor
    best_team = team_goal_stats_averages('away').max_by { |_team, average| average }
    Nameable.return_team_name(best_team[0], @data)
  end

  def highest_scoring_home_team
    best_team = team_goal_stats_averages('home').max_by { |_team, average| average }
    Nameable.return_team_name(best_team[0], @data)
  end

  def lowest_scoring_visitor
    worst_team = team_goal_stats_averages('away').min_by { |_team, average| average }
    Nameable.return_team_name(worst_team[0], @data)
  end

  def lowest_scoring_home_team
    worst_team = team_goal_stats_averages('home').min_by { |_team, average| average }
    Nameable.return_team_name(worst_team[0], @data)
  end

  def team_goal_stats_averages(hoa_type = nil)
    # hoa_type determines which hash is returned
    # "home" and "away" return average goals for the given game type
    # defaults to total games
    teams_goals_stats = {}
    @data[:game_teams].each do |row|
      teams_goals_stats[row[:team_id]] = [0, 0]
      # [games, goals]
    end
    if hoa_type == 'home'
      @data[:game_teams].each do |row|
        if row[:hoa] == 'home'
          add_to_total(row, teams_goals_stats)
        end
      end
    elsif hoa_type == 'away'
      @data[:game_teams].each do |row|
        if row[:hoa] == 'away'
          add_to_total(row, teams_goals_stats)
        end
      end
    else
      @data[:game_teams].each do |row|
        add_to_total(row, teams_goals_stats)
      end
    end
    teams_goals_stats.each do |team, stat|
      teams_goals_stats[team] = (stat[1] / stat[0]).round(2)
    end
    teams_goals_stats
  end

  def add_to_total(row, teams_goals_stats)
    teams_goals_stats[row[:team_id]][0] += 1
    teams_goals_stats[row[:team_id]][1] += row[:goals].to_f
  end
end
