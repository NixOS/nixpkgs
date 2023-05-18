{ lib
, runCommand
, src
, version
}:
runCommand "serenity-headers-${version}" {
  meta = with lib; {
    description = "Header files for the SerenityOS kernel and LibC";
    homepage = "https://serenityos.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.serenity;
  };
}
''
  cd ${src}
  FILES=$(find \
          AK \
          Kernel/API \
          Kernel/Arch \
          Userland/Libraries/LibC \
          -name '*.h' -print)
  for header in $FILES; do
    target=$(echo "$header" | sed -e "s|Userland/Libraries/LibC||")
    mkdir -p "$(dirname "$out/include/$target")"
    cp "$header" "$out/include/$target"
  done
''
