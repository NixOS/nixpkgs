{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pprof";
  version = "0-unstable-2024-07-10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "pprof";
    rev = "f6c9dda6c6da638264f96f1097bce50fd82b4927";
    hash = "sha256-jxPl3e9aYRWyR7vkz+15aZiG331WnrNkMW8vwbcldfY=";
  };

  postPatch = ''
    rm -rf browsertests   # somewhat independent module to ignore.
  '';

  vendorHash = "sha256-oOjkjVb3OIGMwz3/85KTewXISpBZM3o1BfFG9aysFbo=";

  meta = with lib; {
    description = "Tool for visualization and analysis of profiling data";
    homepage = "https://github.com/google/pprof";
    license = licenses.asl20;
    longDescription = ''
      pprof reads a collection of profiling samples in profile.proto format and
      generates reports to visualize and help analyze the data. It can generate
      both text and graphical reports (through the use of the dot visualization
      package).

      profile.proto is a protocol buffer that describes a set of callstacks and
      symbolization information. A common usage is to represent a set of sampled
      callstacks from statistical profiling. The format is described on the
      proto/profile.proto file. For details on protocol buffers, see
      https://developers.google.com/protocol-buffers

      Profiles can be read from a local file, or over http. Multiple profiles of
      the same type can be aggregated or compared.

      If the profile samples contain machine addresses, pprof can symbolize them
      through the use of the native binutils tools (addr2line and nm).

      This is not an official Google product.
    '';
    mainProgram = "pprof";
    maintainers = with maintainers; [ hzeller ];
  };
}
