system 'rm Gemfile' if File.exist?('Gemfile')
File.write('Gemfile', <<-GEMFILE)
  source 'https://rubygems.org'

gem 'minitest', '~> 5.8', '>= 5.8.4'
gem 'logger', '~> 1.2', '>= 1.2.8'
GEMFILE

system 'bundle install'

require 'bundler'
Bundler.setup(:default)

require 'minitest/autorun'
require 'logger'

require './league_table.rb'

describe LeagueTable do
  before do
    @lt = LeagueTable.new
  end

  describe 'matches#push' do
    it 'should ignore wrong data' do
      @lt.matches.push 'Man Utd 3 - 0 '
      @lt.teams.count.must_equal 0

      @lt.matches.push ' 3 - 0 Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man Utd 3 - Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man Utd - 0 Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man Utd 3  0 Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man -- 0 Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man Utd 3 -- 0 Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man Utd - Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push 'Man Utd 3 3 - 0 Liverpool'
      @lt.teams.count.must_equal 0

      @lt.matches.push'Man Utd 3 - 0 0 Liverpool'
      @lt.teams.count.must_equal 0
    end

    it 'should allow correct data' do
      @lt.matches.push 'Man Utd 3 - 0 Liverpool'
      @lt.teams.count.must_equal 2
    end
  end

  describe '#get_[:points, :goals_for, :goals_against, :goal_difference, :wins, :draws, :losses]' do
    it 'default value should be 0' do
      @lt.teams.count.must_equal 0

      @lt.get_points('Man Utd').must_equal 0
      @lt.get_goals_for('Man Utd').must_equal 0
      @lt.get_goals_against('Man Utd').must_equal 0
      @lt.get_goal_difference('Man Utd').must_equal 0
      @lt.get_wins('Man Utd').must_equal 0
      @lt.get_draws('Man Utd').must_equal 0
      @lt.get_losses('Man Utd').must_equal 0

      @lt.get_points('Liverpool').must_equal 0
      @lt.get_goals_for('Liverpool').must_equal 0
      @lt.get_goals_against('Liverpool').must_equal 0
      @lt.get_goal_difference('Liverpool').must_equal 0
      @lt.get_wins('Liverpool').must_equal 0
      @lt.get_draws('Liverpool').must_equal 0
      @lt.get_losses('Liverpool').must_equal 0
    end

    it 'should have right calculation' do
      @lt.matches.push('Man Utd 3 - 0 Liverpool')

      @lt.get_points('Man Utd').must_equal 3
      @lt.get_goals_for('Man Utd').must_equal 3
      @lt.get_goals_against('Man Utd').must_equal 0
      @lt.get_goal_difference('Man Utd').must_equal 3
      @lt.get_wins('Man Utd').must_equal 1
      @lt.get_draws('Man Utd').must_equal 0
      @lt.get_losses('Man Utd').must_equal 0

      @lt.get_points('Liverpool').must_equal 0
      @lt.get_goals_for('Liverpool').must_equal 0
      @lt.get_goals_against('Liverpool').must_equal 3
      @lt.get_goal_difference('Liverpool').must_equal -3
      @lt.get_wins('Liverpool').must_equal 0
      @lt.get_draws('Liverpool').must_equal 0
      @lt.get_losses('Liverpool').must_equal 1

      @lt.matches.push('Liverpool 1 -  1 Jagiellonia')

      @lt.get_points('Liverpool').must_equal 1
      @lt.get_goals_for('Liverpool').must_equal 1
      @lt.get_goals_against('Liverpool').must_equal 4
      @lt.get_goal_difference('Liverpool').must_equal -3
      @lt.get_wins('Liverpool').must_equal 0
      @lt.get_draws('Liverpool').must_equal 1
      @lt.get_losses('Liverpool').must_equal 1

      @lt.get_points('Jagiellonia').must_equal 1
      @lt.get_goals_for('Jagiellonia').must_equal 1
      @lt.get_goals_against('Jagiellonia').must_equal 1
      @lt.get_goal_difference('Jagiellonia').must_equal 0
      @lt.get_wins('Jagiellonia').must_equal 0
      @lt.get_draws('Jagiellonia').must_equal 1
      @lt.get_losses('Jagiellonia').must_equal 0

      @lt.matches.push('Jagiellonia 3 - 4 man utd')

      @lt.get_points('man Utd').must_equal 6
      @lt.get_goals_for('Man Utd').must_equal 7
      @lt.get_goals_against('Man Utd').must_equal 3
      @lt.get_goal_difference('Man Utd').must_equal 4
      @lt.get_wins('Man Utd').must_equal 2
      @lt.get_draws('Man Utd').must_equal 0
      @lt.get_losses('Man Utd').must_equal 0

      @lt.get_points('JagieLlonia').must_equal 1
      @lt.get_goals_for('JAgiellonia').must_equal 4
      @lt.get_goals_against('Jagiellonia').must_equal 5
      @lt.get_goal_difference('Jagiellonia').must_equal -1
      @lt.get_wins('JagielloniA').must_equal 0
      @lt.get_draws('Jagiellonia').must_equal 1
      @lt.get_losses('Jagiellonia').must_equal 1

      @lt.matches.push('Borussia 1 -  1 Bayern')

      @lt.get_points('Borussia').must_equal 1
      @lt.get_goals_for('Borussia').must_equal 1
      @lt.get_goals_against('Borussia').must_equal 1
      @lt.get_goal_difference('Borussia').must_equal 0
      @lt.get_wins('Borussia').must_equal 0
      @lt.get_draws('Borussia').must_equal 1
      @lt.get_losses('Borussia').must_equal 0

      @lt.get_points('Bayern').must_equal 1
      @lt.get_goals_for('Bayern').must_equal 1
      @lt.get_goals_against('Bayern').must_equal 1
      @lt.get_goal_difference('Bayern').must_equal 0
      @lt.get_wins('Bayern').must_equal 0
      @lt.get_draws('Bayern').must_equal 1
      @lt.get_losses('Bayern').must_equal 0
    end
  end

end

