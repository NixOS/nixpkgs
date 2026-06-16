{ lib
, stdenv
, jq
, curl
, nurl
, nix
, writeShellApplication
, runCommand
}:

{ fetcher, fetcherArgs, syncFiles, getLastVersion ? null }:

let
  submodules = fetcherArgs: if fetcherArgs.fetchSubmodules or false then "true" else "false";

  userGetVersion =
    ''
      if [ ! -d "${getLastVersion}" ] && [ -x "${getLastVersion}" ]; then
          ${getLastVersion}
      else
          bin=(${getLastVersion}/bin/*)
          ''${bin[0]}
      fi
    '';

  scriptArgs =
    if fetcher == "fetchFromGitHub" then
      assert fetcherArgs ? "owner";
      assert fetcherArgs ? "repo";
      let
        repo = "${fetcherArgs.owner}/${fetcherArgs.repo}";
        domain = fetcherArgs.domain or "github.com";
      in
      {
        getVersionCmd = ''get_last_github_tag "${repo}" "${domain}"'';
        upstreamUrl = "https://${domain}/${repo}";
      }

    else if fetcher == "fetchgit" then
      assert fetcherArgs ? "url";
      {
        getVersionCmd = ''get_last_git_tag "${fetcherArgs.url}"'';
        upstreamUrl = fetcherArgs.url;
      }

    else abort "Invalid fetcher: ${fetcher}";

  nixpkgsUpdater = writeShellApplication
    {
      name = "nixpkgs-updater-script";

      runtimeInputs = [ nix curl jq nurl ];

      text =
        let getVersionCmd = if !(builtins.isNull getLastVersion) then userGetVersion else scriptArgs.getVersionCmd; in
        ''
          # shellcheck disable=1091
          source ${./utils.sh}
          version=$(${getVersionCmd})
          nurl_info=$(get_nurl_info "${fetcher}" "${scriptArgs.upstreamUrl}" "$version" "${submodules fetcherArgs}")
          update_info '${builtins.toJSON fetcherArgs}' '${builtins.toJSON syncFiles}' "$nurl_info"
        '';
    };
in
runCommand "nixpkgs-updater" { }
  ''
    ln -s ${nixpkgsUpdater}/bin/nixpkgs-updater-script $out
  ''
