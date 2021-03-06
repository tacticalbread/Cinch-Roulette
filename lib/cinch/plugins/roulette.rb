#!/usr/bin/env ruby
# encoding=utf-8

# These are all very annoying.
# rubocop:disable Metrics/LineLength, Metrics/ClassLength, Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize

module Cinch
  module Plugins
    # Roulette game
    class Roulette
      include Cinch::Plugin

      private

      def initialize(*args)
        super
        @shells = {}
        @shot = {}
      end

      public

      match(/spin$/, method: :spin)
      def spin(m)
        @shells[m.channel] = 6
        @shot[m.channel] = rand(1..@shells[m.channel])
        lines = '=' * 10
        puts "#{lines}\nShells left: #{@shells[m.channel]}"
        puts "Hot shot: #{@shot[m.channel]}\n#{lines}"
        m.action_reply 'spins the chamber!'
      end

      match(/rr$/, method: :rr)
      def rr(m)
        # just starting?
        @shells[m.channel] = 6 if @shells[m.channel].nil?
        @shot[m.channel] = rand(1..@shells[m.channel]) if @shot[m.channel].nil?

        shooter = m.user.nick
        # Cheating in the console
        lines = '=' * 10
        puts "#{lines}\nShells left: #{@shells[m.channel]}"
        puts "Hot shot: #{@shot[m.channel]}\n#{lines}"

        if @shot[m.channel] == @shells[m.channel]
          @shells[m.channel] = 6
          @shot[m.channel] = rand(1..@shells[m.channel])
          m.reply 'Bang!'
          m.channel.kick(shooter, 'Bad luck, you\'re dead!')
          sleep(2)
          m.action_reply 'reloads the revolver and spins the chamber!'
        else
          m.reply 'Click!'
          @shells[m.channel] -= 1
        end
      end
    end
  end
end

# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab foldmethod=syntax:
