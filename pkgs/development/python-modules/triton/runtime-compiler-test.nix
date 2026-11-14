{
  python,
  runCommand,
  triton,
}:
let
  pythonEnv = python.withPackages (_: [ triton ]);
in
runCommand "${triton.name}-runtime-compilers" { } ''
  mkdir -p "$out" "$TMPDIR/home" "$TMPDIR/bin"
  env -i HOME="$TMPDIR/home" TMPDIR="$TMPDIR" PATH="$TMPDIR/bin" \
    ${pythonEnv.interpreter} - "$out" <<'PYTHON'
  import ctypes
  from pathlib import Path
  import shutil
  import sys
  from triton.runtime.build import compile_so_from_src

  assert not any(shutil.which(tool) for tool in ("cc", "c++", "gcc", "g++", "clang", "clang++"))
  for language in ("c", "c++"):
      name = "answer_" + language.replace("+", "x")
      source = (
          '#include <sstream>\nextern "C" int answer() { std::ostringstream s; s << 42; return std::stoi(s.str()); }'
          if language == "c++" else "int answer(void) { return 42; }"
      )
      library = compile_so_from_src(source, name, language=language)
      assert ctypes.CDLL(library).answer() == 42
      Path(sys.argv[1], name).touch()
  PYTHON
''
