{
  afterglow = ''
    substituteInPlace ./shared/gimxcontroller/include/x360.h \
      --replace "0x045e" "0x0e6f" --replace "0x028e" "0x0213"

    HEX="./loader/firmware/EMU360.hex"
    sed -i '34s|1B2100|1B2110|' "$HEX"
    sed -i '38s|092100|092110|' "$HEX"
    sed -i '40s|5E048E021001|6F0E13020001|' "$HEX"
    sed -i '34s|1C\r|0C\r|' "$HEX"
    sed -i '38s|FE\r|EE\r|' "$HEX"
    sed -i '40s|6D\r|DD\r|' "$HEX"
  '';
}
