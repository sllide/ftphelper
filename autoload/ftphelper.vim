function ftphelper#GetConfig()
  if filereadable('.conn')
    let connection = readfile('.conn')
    return connection
  endif
  return 0
endfunction

function ftphelper#GetExcludeRules()
  if exists("s:excludeList")
    return s:excludeList
  endif
  let s:excludeList = " "
  if exists('g:ftphelper_excludes')
    if type(g:ftphelper_excludes) == v:t_list
      for rule in g:ftphelper_excludes
        let s:excludeList .= "--exclude-glob '" . rule . "' "
      endfor
    endif
  endif
  return s:excludeList
endfunction

function ftphelper#GetIncludeRules()
  if exists("s:includeList")
    return s:includeList
  endif
  let s:includeList = " "
  if exists('g:ftphelper_includes')
    if type(g:ftphelper_includes) == v:t_list
      for rule in g:ftphelper_includes
        let s:includeList .= "--include-glob '" . rule . "' "
      endfor
    endif
  endif
  return s:includeList
endfunction

function ftphelper#PushFtpSingle(path)
  let conn = ftphelper#GetConfig()
  if type(conn) == v:t_list
    silent execute "!lftp -e \"put ".a:path." -o ".a:path."; exit;\" ftp://".conn[1].":".conn[2]."@".conn[0]
  endif
endfunction

function ftphelper#PushFtp()
  let conn = ftphelper#GetConfig()
  if type(conn) == v:t_list
    let excludeSTR = ftphelper#GetExcludeRules()
    let includeSTR = ftphelper#GetIncludeRules()
    echo "Pushing ftp host ".conn[1]."@".conn[0]
    silent execute "!lftp -e \"mirror -Rne --exclude-glob '*.conn' ".excludeSTR." ".includeSTR." --use-pget-n=10 . .;exit;\" ftp://".conn[1].":".conn[2]."@".conn[0]
    echo "Upload finished"
  endif
endfunction

function ftphelper#PullFtp()
  let conn = ftphelper#GetConfig()
  if type(conn) == v:t_list
    let excludeSTR = ftphelper#GetExcludeRules()
    let includeSTR = ftphelper#GetIncludeRules()
    echo conn
    echo excludeSTR
    echo includeSTR
    echo "Pulling ftp host ".conn[1]."@".conn[0]
    silent execute "!lftp -e \"mirror -ne --exclude-glob '*.*' ".excludeSTR." ".includeSTR." --use-pget-n=10 . .;exit;\" ftp://".conn[1].":".conn[2]."@".conn[0]
    echo "Download finished"
  endif
endfunction
