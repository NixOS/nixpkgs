const R = require('ramda')

const urlToName = require('./urlToName')
const { execFileSync } = require('child_process')

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

function prefetchgit(url, rev) {
  return JSON.parse(
    execFileSync("nix-prefetch-git", ["--rev", rev, url, "--fetch-submodules"], {
      stdio: [ "ignore", "pipe", "ignore" ],
      timeout: 60000,
    })
  ).sha256
}

function fetchgit(fileName, url, rev, branch, builtinFetchGit) {
  return `    {
    name = "${fileName}";
    path =
      let${builtinFetchGit ? `
        repo = builtins.fetchGit ({
          url = "${url}";
          ref = "${branch}";
          rev = "${rev}";
        } // (if builtins.substring 0 3 builtins.nixVersion == "2.4" then {
          allRefs = true;
        } else {}));
      ` : `
        repo = fetchgit {
          url = "${url}";
          rev = "${rev}";
          sha256 = "${prefetchgit(url, rev)}";
        };
      `}in
        runCommand "${fileName}" { buildInputs = [gnutar]; } ''
          # Set u+w because tar-fs can't unpack archives with read-only dirs
          # https://github.com/mafintosh/tar-fs/issues/79
          tar cf $out --mode u+w -C \${repo} .
        '';
  }`
}

function fetchLockedDep(builtinFetchGit) {
  return function (pkg) {
    const { integrity, nameWithVersion, resolved } = pkg

    if (!resolved) {
      console.error(
        `yarn2nix: can't find "resolved" field for package ${nameWithVersion}, you probably required it using "file:...", this feature is not supported, ignoring`,
      )
      return ''
    }

    const [url, sha1OrRev] = resolved.split('#')

    const fileName = urlToName(url)

    if (resolved.startsWith('https://codeload.github.com/')) {
      const s = resolved.split('/')
      const githubUrl = `https://github.com/${s[3]}/${s[4]}.git`
      const githubRev = s[6]

      const [_, branch] = nameWithVersion.split('#')

      return fetchgit(fileName, githubUrl, githubRev, branch || 'master', builtinFetchGit)
    }

    if (url.startsWith('git+') || url.startsWith("git:")) {
      const rev = sha1OrRev

      const [_, branch] = nameWithVersion.split('#')

      const urlForGit = url.replace(/^git\+/, '')

      return fetchgit(fileName, urlForGit, rev, branch || 'master', builtinFetchGit)
    }

    const [algo, hash] = integrity ? integrity.split('-') : ['sha1', sha1OrRev]

    return `    {
      name = "${fileName}";
      path = fetchurl {
        name = "${fileName}";
        url  = "${url}";
        ${algo} = "${hash}";
      };
    }`
  }
}

const HEAD = `
{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
`.trim()

// Object -> String
function generateNix(pkgs, builtinFetchGit) {
  const nameWithVersionAndPackageNix = R.map(fetchLockedDep(builtinFetchGit), pkgs)

  const packagesDefinition = R.join(
    '\n',
    R.values(nameWithVersionAndPackageNix),
  )

  return R.join('\n', [HEAD, packagesDefinition, '  ];', '}'])
}

module.exports = generateNix
