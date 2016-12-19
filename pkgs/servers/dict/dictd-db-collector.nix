{stdenv, lib, dict}:
({dictlist, allowList ? ["127.0.0.1"], denyList ? []}:
/*
 dictlist is a list of form 
 [ { filename = /path/to/files/basename;
 name = "name"; } ]
 basename.dict.dz and basename.index should be 
 dict files. Or look below for other options.
 allowList is a list of IP/domain *-wildcarded strings
 denyList is the same..
*/

let
	link_arguments = map 
			(x: '' "${x.filename}" '')
			dictlist; 
	databases = lib.concatStrings (map (x : 
		"${x.name}	${x.filename}\n") dictlist);
	allow = lib.concatStrings (map (x: "allow ${x}\n") allowList);
	deny = lib.concatStrings (map (x: "deny ${x}\n") denyList);
	accessSection = "
		access {
			${allow}
			${deny}
		}
	";
	installPhase = ''  
  	mkdir -p $out/share/dictd
	cd $out/share/dictd
	echo "${databases}" >databases.names 
	echo "${accessSection}" > dictd.conf
	for j in ${toString link_arguments}; do 
		name="$(egrep '	'"$j"\$ databases.names)"
		name=''${name%	$j}
		if test -d "$j"; then
			if test -d "$j"/share/dictd ; then
				echo "Got store path $j"
				j="$j"/share/dictd 
			fi
			echo "Directory reference: $j"
			i=$(ls "$j""/"*.index)
			i="''${i%.index}";
		else
			i="$j";
		fi
		echo "Basename is $i"
		locale=$(cat "$(dirname "$i")"/locale)
		base="$(basename "$i")"
		echo "Locale is $locale"
		export LC_ALL=$locale 
		export LANG=$locale 
		if test -e "$i".dict.dz; then
			ln -s "$i".dict.dz
		else
			cp "$i".dict .
			dictzip "$base".dict
		fi
		ln -s "$i".index .
		dictfmt_index2word --locale $locale < "$base".index > "$base".word || true
		dictfmt_index2suffix --locale $locale < "$base".index > "$base".suffix || true

		echo "database $name {" >> dictd.conf
		echo "  data $out/share/dictd/$base.dict.dz" >> dictd.conf
		echo "  index $out/share/dictd/$base.index" >> dictd.conf
		echo "  index_word $out/share/dictd/$base.word" >> dictd.conf
		echo "  index_suffix $out/share/dictd/$base.suffix" >> dictd.conf
		echo "}" >> dictd.conf
	done
  	'';

in

stdenv.mkDerivation {
  name = "dictd-dbs";

  phases = ["installPhase"];
  buildInputs = [dict];

  inherit installPhase;
})
