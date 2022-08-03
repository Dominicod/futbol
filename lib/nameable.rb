module Nameable
  def self.return_team_name(team_id, data)
    team_name = (data[:teams].select {|row| row[:team_id] == team_id})[0][:teamname]
  end
end
