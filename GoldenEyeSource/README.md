# GoldenEye: Source Server Command reference

## `changelevel`

End the match and change to the specified level

## `ge_restartround`

End the current round and start the next one. Use this to move to the next
weapon set quickly.

## `ge_endround`

End the current round. Use ge_endround 0 to skip scores.

## `ge_endround_keepweapons`

End the current round but keep the same weapon set.

## `ge_endmatch`

End the match, loading the next one.

## `ge_gameplaylist`

Print the game modes on the server.

## `ge_gameplaylistrefresh`

Refresh the list of game modes. Useful if you added a gameplay while the server
was running

## `ge_weaponset_list`

Print the weaponsets on the server.

## `ge_weaponset_reload`

Refresh the list of weaponsets. Useful if you added a weaponset while the server
was running.

## `ge_print_map_selection_data`

Print the server’s map selection data.

## `ge_print_current_map_data` Print the current map’s data.

## `ge_print_map_selection_weights`

Print the map selection chance for given player count, or current playercount if
none is given. Use 1 as second parameter for unsorted list.

## `ge_bot` Adds a bot.

## `ge_bot_remove` Removes number of bots. If no number is supplied it removes
  them all.