command PullFtp :call ftphelper#PullFtp()
command PushFtp :call ftphelper#PushFtp()
autocmd BufWritePost * :call ftphelper#PushFtpSingle(@%)
