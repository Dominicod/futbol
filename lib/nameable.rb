module Nameable
  def self.return_team_name(team_id, data)
    team_name = nil
    data[:teams].each do |row|
      team_name = row[:teamname] if row[:team_id] == team_id
    end
    team_name
  end
end
