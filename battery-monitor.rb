#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './setup'

player = if OS.mac?
           'afplay -v 0.2'
         else
           'aplay'
         end
exit(false) unless program_installed? player.split(/\s/).first

sound_path = "#{HOME}/.zsh-sounds/battery-alert.wav"
exit(false) unless File.exist? sound_path

loop do
  state, value = `#{DF_PATH}/tmux/battery.#{OS.mac? ? 'osx' : 'linux'}.zsh`.split("\n")

  if state != 'charging' && value.to_i < 10
    `#{player} #{sound_path} > /dev/null 2>&1`
    sleep 2
    next
  end

  sleep 20
end