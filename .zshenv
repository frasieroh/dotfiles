# This must be in zshenv since it must be executed before zprofile.
# This disables loading completions outselves. The completions plugin
# will take care of that for us.
export skip_global_compinit=1
