require './matches.rb'

class LeagueTable
  FIELDS = [:points, :goals_for, :goals_against, :goal_difference, :wins, :draws, :losses]

  attr_accessor :matches, :teams

  def initialize
    @matches = Matches.new(self)
    @teams = {}
  end

  FIELDS.each do |method|
    define_method("get_#{method}") do |team|
      team = team.squeeze(' ').strip.downcase
      @teams[team] ? @teams[team][method] : 0
    end
  end

  def push_result(match_data)
    team1, score1, team2, score2 = match_data
    push_team_result(team1, score1, score2)
    push_team_result(team2, score2, score1)
  end

  def push_team_result(team, scored, missed)
    init_team(team)
    update_table team, match_result(scored, missed)
  end

  private

  def match_result(scored, missed)
    match_result = if scored < missed
                     {losses: 1}
                   elsif scored > missed
                     {wins: 1, points: 3}
                   else
                     {draws: 1, points: 1}
                   end

    match_result.merge({
      goals_for: scored,
      goals_against: missed,
      goal_difference: scored - missed
    })
  end

  def update_table(team, fields)
    if @teams[team]
      fields.each_pair {|key, value| @teams[team][key] += value }
    end
  end

  def init_team(team)
    unless @teams.has_key?(team)
      @teams[team] = {}
      FIELDS.each { |f| @teams[team][f] = 0 }
    end
  end

end
