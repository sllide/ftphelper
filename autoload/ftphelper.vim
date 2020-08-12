function! ftphelper#GetConfig()
  if filereadable('.conn')
    let connection = readfile('.conn')
    if len(connection) == 5
      return connection
    endif
    echo ".conn needs 5 lines: protocol, host, user, pass, directory"
    return 0
  endif
  return 0
endfunction

function! ftphelper#IsPartOfProjectDir(path)
  let pwd = getcwd()
  let path = a:path
  if filereadable(pwd.'/'.path)
    return 1
  endif
  return 0
endfunction

function! ftphelper#GetExcludeRules()
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

function! ftphelper#GetIncludeRules()
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

function! ftphelper#PushFtpSingle(path)
  if a:path == ".conn"
    return
  endif
  let conn = ftphelper#GetConfig()
  if type(conn) == v:t_list
    if ftphelper#IsPartOfProjectDir(a:path)
      silent execute "!lftp -e \"put ".a:path." -o ".conn[4].'/'.a:path."; exit;\" \"".conn[0]."://".conn[2].":".conn[3]."@".conn[1]."\""
    endif
  endif
endfunction

function! ftphelper#PushFtp()
  let conn = ftphelper#GetConfig()
  if type(conn) == v:t_list
    let excludeSTR = ftphelper#GetExcludeRules()
    let includeSTR = ftphelper#GetIncludeRules()
    echo "Pushing ".conn[0]." host ".conn[2]."@".conn[1]
    execute "!lftp -e \"mirror -Rn --exclude-glob '*.conn' ".excludeSTR." ".includeSTR." --parallel=10 . ".conn[4].";exit;\" \"".conn[0]."://".conn[2].":".conn[3]."@".conn[1]."\""
    echo "Upload finished"
  endif
endfunction

function! ftphelper#PullFtp()
  let conn = ftphelper#GetConfig()
  if type(conn) == v:t_list
    let excludeSTR = ftphelper#GetExcludeRules()
    let includeSTR = ftphelper#GetIncludeRules()
    echo "Pulling ".conn[0]." host ".conn[2]."@".conn[1]
    execute "!lftp -e \"mirror -n --exclude-glob '*.*' ".excludeSTR." ".includeSTR." --parallel=10 ".conn[4]." .;exit;\" \"".conn[0]."://".conn[2].":".conn[3]."@".conn[1]."\""
    echo "Download finished"
  endif
endfunction
