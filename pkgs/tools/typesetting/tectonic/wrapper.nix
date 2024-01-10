{ lib
, symlinkJoin
, tectonic-unwrapped
, biber-for-tectonic
, makeWrapper
}:

symlinkJoin {
  name = "${tectonic-unwrapped.pname}-wrapped-${tectonic-unwrapped.version}";
  paths = [ tectonic-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    unwrapped = tectonic-unwrapped;
    biber = biber-for-tectonic;
  };

  # Replace the unwrapped tectonic with the one wrapping it with biber
  postBuild = ''
    rm $out/bin/{tectonic,nextonic}
  ''
    # Ideally, we would have liked to also pin the version of the online TeX
    # bundle that Tectonic's developer distribute, so that the `biber` version
    # and the `biblatex` version distributed from there are compatible.
    # However, that is not currently possible, due to lack of upstream support
    # for specifying this in runtime, there were 2 suggestions sent upstream
    # that suggested a way of improving the situation:
    #
    # - https://github.com/tectonic-typesetting/tectonic/pull/1132
    # - https://github.com/tectonic-typesetting/tectonic/pull/1131
    #
    # The 1st suggestion seems more promising as it'd allow us to simply use
    # makeWrapper's --add-flags option. However, the PR linked above is not
    # complete, and as of currently, upstream hasn't even reviewed it, or
    # commented on the idea.
    #
    # Note also that upstream has announced that they will put less time and
    # energy for the project:
    #
    # https://github.com/tectonic-typesetting/tectonic/discussions/1122
    #
    # Hence, we can be rather confident that for the near future, the online
    # TeX bundle won't be updated and hence the biblatex distributed there
    # won't require a higher version of biber.
  + ''
    makeWrapper ${lib.getBin tectonic-unwrapped}/bin/tectonic $out/bin/tectonic \
      --prefix PATH : "${lib.getBin biber-for-tectonic}/bin"
    ln -s $out/bin/tectonic $out/bin/nextonic
  '';

  meta = tectonic-unwrapped.meta // {
    description = "Tectonic TeX/LaTeX engine, wrapped with a compatible biber";
    maintainers = with lib.maintainers; [ doronbehar bryango ];
  };
}
