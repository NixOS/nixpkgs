const R = require('ramda')

const urlToName = require('./urlToName')

// fetchgit transforms
//
// "shell-quote@git+https://github.com/srghma/node-shell-quote.git#without_unlicenced_jsonify":
//   version "1.6.0"
//   resolved "git+https://github.com/srghma/node-shell-quote.git#1234commit"
//
// to
//
// builtins.fetchGit {
//   url = "https://github.com/srghma/node-shell-quote.git";
//   ref = "without_unlicenced_jsonify";
//   rev = "1234commit";
// }
//
// and transforms
//
// "@graphile/plugin-supporter@git+https://1234user:1234pass@git.graphile.com/git/users/1234user/postgraphile-supporter.git":
//   version "0.6.0"
//   resolved "git+https://1234user:1234pass@git.graphile.com/git/users/1234user/postgraphile-supporter.git#1234commit"
//
// to
//
// builtins.fetchGit {
//   url = "https://1234user:1234pass@git.graphile.com/git/users/1234user/postgraphile-supporter.git";
//   ref = "master";
//   rev = "1234commit";
// }

function fetchgit(fileName, url, rev, branch) {
  return `    {
    name = "${fileName}";
    path =
      let
        repo = builtins.fetchGit {
          url = "${url}";
          ref = "${branch}";
          rev = "${rev}";
        };
      in
        runCommandNoCC "${fileName}" { buildInputs = [gnutar]; } ''
          # Set u+w because tar-fs can't unpack archives with read-only dirs
          # https://github.com/mafintosh/tar-fs/issues/79
          tar cf $out --mode u+w -C \${repo} .
        '';
  }`
}

function fetchLockedDep(pkg) {
  const { nameWithVersion, resolved } = pkg

  if (!resolved) {
    console.error(
      `yarn2nix: can't find "resolved" field for package ${nameWithVersion}, you probably required it using "file:...", this feature is not supported, ignoring`,
    )
    return ''
  }

  const [url, sha1OrRev] = resolved.split('#')

  const fileName = urlToName(url)

  if (url.startsWith('git+')) {
    const rev = sha1OrRev

    const [_, branch] = nameWithVersion.split('#')

    const urlForGit = url.replace(/^git\+/, '')

    return fetchgit(fileName, urlForGit, rev, branch || 'master')
  }

  const sha = sha1OrRev

  return `    {
      name = "${fileName}";
      path = fetchurl {
        name = "${fileName}";
        url  = "${url}";
        sha1 = "${sha}";
      };
    }`
}

const HEAD = `
{ fetchurl, linkFarm, runCommandNoCC, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
`.trim()

// Object -> String
function generateNix(pkgs) {
  const nameWithVersionAndPackageNix = R.map(fetchLockedDep, pkgs)

  const packagesDefinition = R.join(
    '\n',
    R.values(nameWithVersionAndPackageNix),
  )

  return R.join('\n', [HEAD, packagesDefinition, '  ];', '}'])
}

module.exports = generateNix
