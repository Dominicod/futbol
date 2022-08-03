
class SeasonStatistics
  def initialize(data)
    @data = data
  end

  def season_game_id_verification
    @data[:games].all? {|row| row[:game_id][0, 4] == row[:season][0, 4]}
  end

  def winningest_coach(season)
    (coach_percent(season).max_by { |_coach, stat| stat }).shift
  end

  def worst_coach(season)
    (coach_percent(season).min_by { |_coach, stat| stat }).shift
  end

  def most_accurate_team(season)
    most_accurate = goal_percentage(season).max_by { |_team, average| average }
    return_team_name(most_accurate[0])
  end

  def least_accurate_team(season)
    least_accurate = goal_percentage(season).min_by { |_team, average| average }
    return_team_name(least_accurate[0])
  end

  def most_tackles(season)
    most_tackles = total_tackles(season).max_by { |_team, tackles| tackles }
    return_team_name(most_tackles[0])
  end

  def fewest_tackles(season)
    fewest_tackles = total_tackles(season).min_by { |_team, tackles| tackles }
    return_team_name(fewest_tackles[0])
  end

  def goal_percentage(season)
    season_data = season_data(season)
    team_shot_percentage = Hash.new
    season_data.each do |row|
      team_shot_percentage.store(row[:team_id], [0.0, 0.0])
    end
    season_data.each do |row|
      team_shot_percentage[row[:team_id]][0] += row[:goals].to_f
      team_shot_percentage[row[:team_id]][1] += row[:shots].to_f
    end
    team_shot_percentage.each do |team, stat|
      team_shot_percentage[team] = (stat[0] / stat[1]).round(4)
    end
  end

  def coach_percent(season)
    season_data = season_data(season)
    coaches_games = {}
    season_data.each do |row|
      coaches_games.store(row[:head_coach], [0.0, 0.0, 0.0])
    end
    season_data.each do |row|
      update_total_count(row, coaches_games)
    end
    coaches_games.each do |coach, stat|
      coaches_games[coach] = (stat[1] / stat[0]).round(2)
    end
  end

  def update_total_count(row, coaches_games)
    coaches_games[row[:head_coach]][0] += 1
    if row[:result] == 'WIN'
      coaches_games[row[:head_coach]][1] += 1
    elsif row[:result] == 'LOSS'
      coaches_games[row[:head_coach]][2] += 1
    end
  end

  def return_team_name(team_id)
    team_name = (@data[:teams].select {|row| row[:team_id] == team_id})[0][:teamname]
  end

  def total_tackles(season)
    season_data = season_data(season)
    total_tackles_hash = Hash.new([0.0])
    season_data.each do |row|
      total_tackles_hash.store(row[:team_id], [0.0])
    end
    season_data.each do |row|
      total_tackles_hash[row[:team_id]][0] += row[:tackles].to_f
    end
    total_tackles_hash
  end

  def season_data(season)
    season_data = @data[:game_teams].select do |row|
      row[:game_id][0, 4] == season[0, 4]
    end
  end
end
