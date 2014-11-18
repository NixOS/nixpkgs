{ loadRubyEnv }:

(loadRubyEnv { gemset = ./gemset.nix; }).riemann-dash
