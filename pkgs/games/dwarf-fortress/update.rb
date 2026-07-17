#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ curb nokogiri ])" nix-prefetch-git

require 'set'
require 'json'
require 'uri'
require 'shellwords'
require 'erb'
require 'rubygems'
require 'curb'
require 'nokogiri'

# Performs a GET to an arbitrary address.
# +url+:: the URL
def get url, &block
  curl = Curl::Easy.new(url) do |http|
    http.follow_location = false
    http.headers['User-Agent'] = 'nixpkgs dwarf fortress update bot'
    yield http if block_given?
  end

  curl.perform
  curl.body_str
end

# Performs a GET on the Github API.
# +url+:: the relative URL to api.github.com
def get_gh url, &block
  ret = get URI.join('https://api.github.com/', url) do |http|
    http.headers['Accept'] = 'application/vnd.github+json'
    http.headers['Authorization'] = "Bearer #{ENV['GH_TOKEN']}" if ENV.include?('GH_TOKEN')
    http.headers['X-GitHub-Api-Version'] = '2022-11-28'
    yield http if block_given?
  end
  JSON.parse(ret, symbolize_names: true)
end

def normalize_keys hash
  Hash[hash.map {
    [
      _1.to_s,
      _2.is_a?(Hash) ? normalize_keys(_2) : _2
    ]
  }]
end

module Mergeable
  # Merges this Mergeable with something else.
  # +other+:: The other Mergeable.
  def merge other
    if !other
      return self
    end

    if !other.is_a?(Mergeable) || self.members != other.members
      raise "invalid right-hand operand for merge: #{other.members}"
    end

    hash = {}
    self.members.each do |member|
      if @@expensive && @@expensive.include?(member)
        # Already computed
        hash[member] = other[member] || self.send(member)
      elsif self.send(member) && self.send(member).is_a?(Mergeable)
        # Merge it
        hash[member] = self.send(member).merge(other.send(member))
      elsif self.send(member) && self.send(member).is_a?(Hash)
        hash[member] = Hash[other.send(member).map {
          [_1, self.send(member)[_1] && self.send(member)[_1].is_a?(Mergeable) ? self.send(member)[_1].merge(_2) : _2]
        }]
      else
        # Compute it
        hash[member] = other.send(member)
      end
    end
    self.class.new(**hash)
  end

  # Marks some attributes as expensive.
  def expensive *attrs
    @@expensive ||= Set.new
    attrs.each {@@expensive << _1}
    self
  end

  # Materializes this object.
  def materialize!
    self.members.each do |name|
      member = self.send(name)
      if member.respond_to?(:materialize!)
        member.materialize!
      end
      self[name] = member
    end
    self
  end
end

module Versionable
  # Parses the version.
  def parsed_version
    @version ||= Gem::Version.create(self.version.partition('-').first)
  end

  # Drops the last component of the version for chunking.
  def major_version
    @major_version ||= Gem::Version.create(self.parsed_version.canonical_segments[..-2].join('.'))
  end

  # Compares the major version.
  def =~ other
    self.major_version == other.major_version
  end

  # Negation of the above.
  def !~ other
    !(self =~ other)
  end

  # Compares two versions.
  def <=> other
    other.parsed_version <=> self.parsed_version
  end
end

class DFUrl < Struct.new(:url, :output_hash, keyword_init: true)
  include Mergeable
  extend Mergeable

  expensive :output_hash

  # Converts this DFUrl to a hash.
  def to_h
    {
      url: self.url,
      outputHash: self.output_hash
    }
  end

  # Returns or computes the output hash.
  def output_hash
    return super if super
    self.output_hash = `nix-prefetch-url #{Shellwords.escape(self.url.to_s)} | xargs nix-hash --to-sri --type sha256`.strip
    super
  end

  # Converts this DFUrl from a hash.
  # +hash+:: The hash
  def self.from_hash hash
    DFUrl.new(
      url: hash.fetch(:url),
      output_hash: hash[:outputHash]
    )
  end
end

class DFGithub < Struct.new(:url, :revision, :output_hash, keyword_init: true)
  include Mergeable
  extend Mergeable

  expensive :output_hash

  # Converts this DFGithub to a hash.
  def to_h
    {
      url: self.url,
      revision: self.revision,
      outputHash: self.output_hash
    }
  end

  # Returns or computes the output hash.
  def output_hash
    return super if super
    url = URI.parse(self.url.to_s)
    if ENV['GH_TOKEN']
      url.userinfo = ENV['GH_TOKEN']
    end
    self.output_hash = JSON.parse(`nix-prefetch-git --no-deepClone --fetch-submodules #{Shellwords.escape(url.to_s)} #{Shellwords.escape(self.revision.to_s)}`, symbolize_names: true).fetch(:hash)
    super
  end

  # Converts a hash to a DFGithub.
  # +hash+:: The hash
  def self.from_hash hash
    DFGithub.new(
      url: hash.fetch(:url),
      revision: hash.fetch(:revision),
      output_hash: hash[:outputHash]
    )
  end
end

class DFVersion < Struct.new(:version, :urls, keyword_init: true)
  include Mergeable
  extend Mergeable
  include Versionable

  # Converts a DFVersion to a hash.
  def to_h
    {
      version: self.version,
      urls: Hash[self.urls.map {
        [_1, _2.to_h]
      }]
    }
  end

  # Converts a hash to a DFVersion.
  # +hash+:: The hash
  def self.from_hash hash
    DFVersion.new(
      version: hash.fetch(:version),
      urls: Hash[hash.fetch(:urls).map {
        [_1, DFUrl.from_hash(_2)]
      }]
    )
  end

  # Converts an HTML node to a DFVersion.
  # +base+:: The base URL for DF downloads.
  # +node+:: The HTML node
  def self.from_node base, node
    match = node.text.match(/DF\s+(\d+\.\d+(?:\.\d+)?)/)
    if match
      systems = {}
      node.css('a').each do |a|
        case a['href']
        when /osx\.tar/ then systems[:darwin] = DFUrl.new(url: URI.join(base, a['href']).to_s)
        when /linux\.tar/ then systems[:linux] = DFUrl.new(url: URI.join(base, a['href']).to_s)
        end
      end

      if systems.empty?
        nil
      else
        DFVersion.new(version: match[1], urls: systems)
      end
    else
      nil
    end
  end

  # Returns all DFVersions from the download page.
  # +cutoff+:: The minimum version
  def self.all cutoff:
    cutoff = Gem::Version.create(cutoff)

    base = 'https://www.bay12games.com/dwarves/'
    res = get URI.join(base, 'older_versions.html')
    parsed = Nokogiri::HTML(res)

    # Figure out which versions we care about.
    parsed.css('p.menu').map {DFVersion.from_node(base, _1)}.select {
      _1 && _1.parsed_version >= cutoff
    }.sort.chunk {
      _1.major_version
    }.map {|*, versions|
      versions.max_by {_1.parsed_version}
    }.to_a
  end
end

class DFHackVersion < Struct.new(:version, :git, :xml_rev, keyword_init: true)
  include Mergeable
  extend Mergeable
  include Versionable

  expensive :xml_rev

  # Returns the download URL.
  def git
    return super if super
    self.git = DFGithub.new(
      url: "https://github.com/DFHack/dfhack.git",
      revision: self.version
    )
    super
  end

  # Converts this DFHackVersion to a hash.
  def to_h
    {
      version: self.version,
      git: self.git.to_h,
      xmlRev: self.xml_rev,
    }
  end

  # Returns the revision number in the version. Defaults to 0.
  def rev
    return @rev if @rev
    rev = self.version.match(/-r([\d\.]+)\z/)
    @rev = rev[1].to_f if rev
    @rev ||= 0
    @rev
  end

  # Returns the XML revision, fetching it if necessary.
  def xml_rev
    return super if super
    url = "repos/dfhack/dfhack/contents/library/xml?ref=#{URI.encode_uri_component(self.git.revision)}"
    body = get_gh url
    self.xml_rev = body.fetch(:sha)
    super
  end

  # Compares two DFHack versions.
  # +other+:: the other dfhack version
  def <=> other
    ret = super
    ret = other.rev <=> self.rev if ret == 0
    ret
  end

  # Returns a version from a hash.
  # +hash+:: the hash
  def self.from_hash hash
    DFHackVersion.new(
      version: hash.fetch(:version),
      git: DFGithub.from_hash(hash.fetch(:git)),
      xml_rev: hash[:xmlRev]
    )
  end

  # Returns a release from a github object.
  # +github_obj+:: The github object. Returns null for prereleases.
  def self.from_github github_obj
    if github_obj.fetch(:prerelease)
      return nil
    end
    version = github_obj.fetch(:tag_name)
    DFHackVersion.new(version: version)
  end

  # Returns all dfhack versions.
  # +cutoff+:: The cutoff version.
  def self.all cutoff:
    cutoff = Gem::Version.create(cutoff)
    ret = {}
    (1..).each do |page|
      url = "repos/dfhack/dfhack/releases?per_page=100&page=#{page}"
      releases = get_gh url

      releases.each do |release|
        release = DFHackVersion.from_github(release)
        if release && release.parsed_version >= cutoff
          ret[release.major_version] ||= {}
          ret[release.major_version][release.parsed_version] ||= []
          ret[release.major_version][release.parsed_version] << release
        end
      end

      break if releases.length < 1
    end

    ret.each do |_, dfhack_major_versions|
      dfhack_major_versions.each do |_, dfhack_minor_versions|
        dfhack_minor_versions.sort!
      end
    end

    ret
  end
end

class DFWithHackVersion < Struct.new(:df, :hack, keyword_init: true)
  include Mergeable
  extend Mergeable

  # Converts this DFWithHackVersion to a hash.
  def to_h
    {
      df: self.df.to_h,
      hack: self.hack.to_h
    }
  end

  # Converts a hash to a DFWithHackVersion.
  # +hash+:: the hash to convert
  def self.from_hash hash
    DFWithHackVersion.new(
      df: DFVersion.from_hash(hash.fetch(:df)),
      hack: DFHackVersion.from_hash(hash.fetch(:hack))
    )
  end
end

class DFWithHackVersions < Struct.new(:latest, :versions, keyword_init: true)
  include Mergeable
  extend Mergeable

  # Initializes this DFWithHackVersions.
  def initialize *args, **kw
    super *args, **kw
    self.latest ||= {}
    self.versions ||= {}
  end

  # Converts this DFWithHackVersions to a hash.
  def to_h
    {
      latest: self.latest,
      versions: Hash[self.versions.map {
        [_1.to_s, _2.to_h]
      }]
    }
  end

  # Loads this DFWithHackVersions.
  # +cutoff+:: The minimum version to load.
  def load! cutoff:
    df_versions = DFVersion.all(cutoff: cutoff)
    dfhack_versions = DFHackVersion.all(cutoff: cutoff)

    df_versions.each do |df_version|
      latest_dfhack_version = nil
      corresponding_dfhack_versions = dfhack_versions.dig(df_version.major_version, df_version.parsed_version)
      if corresponding_dfhack_versions
        latest_dfhack_version = corresponding_dfhack_versions.first
      end

      if latest_dfhack_version
        df_version.urls.each do |platform, url|
          if !self.latest[platform] || df_version.parsed_version > Gem::Version.create(self.latest[platform])
            self.latest[platform] = df_version.version
          end
        end
        self.versions[df_version.version] = DFWithHackVersion.new(df: df_version, hack: latest_dfhack_version)
      end
    end

    self.materialize!
    self
  end

  # Converts a hash to a DFWithHackVersions.
  # +hash+:: The hash
  def self.from_hash hash
    DFWithHackVersions.new(
      latest: hash.fetch(:latest),
      versions: Hash[hash.fetch(:versions).map {
        [_1.to_s, DFWithHackVersion.from_hash(_2)]
      }]
    )
  end
end

class Therapist < Struct.new(:version, :max_df_version, :git, keyword_init: true)
  include Mergeable
  extend Mergeable
  include Versionable

  expensive :max_df_version

  # Converts this Therapist instance to a hash.
  def to_h
    {
      version: self.version,
      maxDfVersion: self.max_df_version,
      git: self.git.to_h
    }
  end

  # Returns the max supported DF version.
  def max_df_version
    return super if super
    url = "repos/Dwarf-Therapist/Dwarf-Therapist/contents/share/memory_layouts/linux?ref=#{URI.encode_uri_component(self.git.revision)}"
    body = get_gh url

    # Figure out the max supported memory layout.
    max_version = nil
    max_version_str = nil
    body.each do |item|
      name = item[:name] || ""
      match = name.match(/\Av(?:0\.)?(\d+\.\d+)-classic_linux\d*\.ini/)
      if match
        version = Gem::Version.create(match[1])
        if !max_version || version > max_version
          max_version = version
          max_version_str = match[1]
        end
      end
    end

    self.max_df_version = max_version_str

    super
  end

  # Returns a Github URL.
  def git
    return super if super
    self.git = DFGithub.new(
      url: "https://github.com/Dwarf-Therapist/Dwarf-Therapist.git",
      revision: 'v' + self.version
    )
    super
  end

  # Loads this therapist instance from Github.
  def load!
    latest = self.class.latest
    self.version = latest.version
    self.max_df_version = latest.max_df_version
    self.git = latest.git
    self.materialize!
    self
  end

  # Loads a hash into this Therapist instance.
  # +hash+: the hash
  def self.from_hash hash
    Therapist.new(
      version: hash.fetch(:version),
      max_df_version: hash[:maxDfVersion],
      git: DFGithub.from_hash(hash.fetch(:git))
    )
  end

  # Returns a release from a github object.
  # +github_obj+:: The github object. Returns null for prereleases.
  def self.from_github github_obj
    if github_obj.fetch(:prerelease)
      return nil
    end

    version = github_obj.fetch(:tag_name)
    match = version.match(/\Av([\d\.]+)\z/)
    if match
      Therapist.new(version: match[1])
    else
      nil
    end
  end

  # Returns the latest Therapist version.
  def self.latest
    url = "repos/Dwarf-Therapist/Dwarf-Therapist/releases"
    releases = get_gh url

    releases.each do |release|
      release = Therapist.from_github(release)
      if release
        return release
      end
    end

    nil
  end
end

class DFLock < Struct.new(:game, :therapist, keyword_init: true)
  include Mergeable
  extend Mergeable

  # Initializes this DFLock.
  def initialize *args, **kw
    super *args, **kw
    self.game ||= DFWithHackVersions.new
    self.therapist ||= Therapist.new
  end

  # Converts this DFLock to a hash.
  def to_h
    {
      game: self.game.to_h,
      therapist: self.therapist.to_h
    }
  end

  # Returns an array containing all versions.
  def all_versions
    [self.game.versions.keys.lazy.map {"DF #{_1}"}.first] + ["DT #{self.therapist.version}"]
  end

  # Loads this DFLock.
  # +cutoff+:: The minimum DF version to load.
  def load! cutoff:
    self.game.load! cutoff: cutoff
    self.therapist.load!
  end

  # Converts a hash to a DFLock.
  # +hash+:: The hash
  def self.from_hash hash
    DFLock.new(
      game: DFWithHackVersions.from_hash(hash.fetch(:game)),
      therapist: Therapist.from_hash(hash.fetch(:therapist))
    )
  end
end

# 0.43 and below has a broken dfhack.
new_df_lock = DFLock.new
new_df_lock.load! cutoff: '0.44'

df_lock_file = File.join(__dir__, 'df.lock.json')
df_lock, df_lock_json = if File.file?(df_lock_file)
                          json = JSON.parse(File.read(df_lock_file), symbolize_names: true)
                          [DFLock.from_hash(json), json]
                        else
                          [DFLock.new, {}]
                        end

new_df_lock_json = df_lock.merge(new_df_lock).to_h
json = JSON.pretty_generate(new_df_lock_json)
json << "\n"
STDERR.puts json
File.write(df_lock_file, json)

# See if there were any changes.
changed_paths = []
if normalize_keys(df_lock_json) != normalize_keys(new_df_lock_json)
  all_old_versions = df_lock.all_versions
  all_new_versions = new_df_lock.all_versions
  just_old_versions = all_old_versions - all_new_versions
  just_new_versions = all_new_versions - all_old_versions
  changes = just_old_versions.zip(just_new_versions)

  template = ERB.new(<<-EOF, trim_mode: '<>-')
dwarf-fortress-packages: <%= changes.map {|old, new| '%s -> %s' % [old, new]}.join('; ') %>

Performed the following automatic DF updates:

<% changes.each do |old, new| %>
- <%= old -%> -> <%= new -%>
<% end %>
EOF

  changed_paths << {
    attrPath: 'dwarf-fortress-packages',
    oldVersion: just_old_versions.join('; '),
    newVersion: just_new_versions.join('; '),
    files: [
      File.realpath(df_lock_file)
    ],
    commitMessage: template.result(binding)
  }
end

STDOUT.puts JSON.pretty_generate(changed_paths)
