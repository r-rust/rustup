#' Install Rust
#'
#' @export
#' @importFrom sys exec_wait
#' @param targets which compiler targets would you like to install
#' @examples rustup_windows()
rustup_windows <- function(targets = c('i686-pc-windows-gnu', 'x86_64-pc-windows-gnu')){
  mypath <- Sys.getenv('PATH')
  if(!grepl('\\.cargo[\\/]bin', mypath)){
    user <- Sys.getenv('USERPROFILE')
    newpath <- paste0(user, "\\.cargo\\bin;", mypath)
    Sys.setenv(PATH = newpath)
  }
  if(!nchar(Sys.which('rustup'))){
    init <- file.path(tempdir(), 'rustup-init.exe')
    utils::download.file('https://win.rustup.rs/', destfile = init, mode = 'wb')    
    if(sys::exec_wait(init, c('-y', '--default-host', 'x86_64-pc-windows-gnu')))
      stop("Failed to run rustup-init")    
  } else {
    if(sys::exec_wait('rustup', c('update', 'stable')))
      stop("Failed to run 'rustup update stable'")
  }
  info <- sys::exec_internal('rustup', 'show')
  for(x in targets){
    if(!grepl(x, rawToChar(info$stdout))){
      if(sys::exec_wait('rustup', c('target', 'add', x)))
        stop("Failed to run rustup target add")
    }
  }
  sys::exec_wait('rustup', 'show')
}
