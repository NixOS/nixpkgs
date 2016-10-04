#!/usr/bin/env ruby
#
#
require "json"

redirects = {
  "collectd.org" => "github.com/collectd/go-collectd",
  "git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git" => "github.com/eclipse/paho.mqtt.golang",
  "golang.org/x/net" => "github.com/golang/net",
  "golang.org/x/crypto" => "github.com/golang/crypto",
  "golang.org/x/text" => "github.com/golang/text",
  "golang.org/x/tools" => "github.com/golang/tools",
  "gopkg.in/fatih/pool.v2" => "github.com/fatih/pool",
}

godeps = ARGV[0] || "Godeps"

deps = File.read(godeps).lines.map do |line|
  (name, rev) = line.split(" ")

  host = redirects.fetch(name, name)

  url = "https://#{host}.git"

  xxx = JSON.load(`nix-prefetch-git #{url} #{rev}`)

  {
    goPackagePath: name,
    fetch: {
      type: "git",
      url: url,
      rev: rev,
      sha256: xxx['sha256'],
    }
  }
end

#TODO: move to deps.nix in NIXON format
File.write("deps.json", JSON.pretty_generate(deps))
