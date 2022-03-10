# Use LuaLaTeX:
$pdf_mode = 4;
# Set custon LuaLaTeX options:
$lualatex = "lualatex %O -shell-escape -file-line-error %S";

# We want the .aux files in a separate temp directory
$aux_dir = "build";
# We need to recreate the directory sub-structure for the .aux files:
system("find . -type d ! -path './.git*' ! -path './$aux_dir*' -exec mkdir -p $aux_dir/{} \\;");
# We also need the 'tikz_cache' directoy inside the build directory, for tikzexternalize:
#system("mkdir -p tikz_cache; mkdir -p $aux_dir/tikz_cache");
# This tells the compiler to move the .pdf files from $aux_dir to $out_dir:
$emulate_aux = 1;
# Finally, keep the thesis.pdf file in the root folder, for VSCode auto-preview:
$out_dir = "./"
