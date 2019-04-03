// Copyright (c) 2018, The TurtleCoin Developers
// Copyright (c) 2019, The HLEBCoin Developers
//
// Please see the included LICENSE file for more information

#pragma once

const std::string windowsAsciiArt =
      "\n  _    _ _      ______ ____   _____ ____ _____ _   _  \n"
       " | |  | | |    |  ____|  _ \\ / ____/ __ \\_   _| \\ | | \n"
       " | |__| | |    | |__  | |_) | |   | |  | || | |  \\| | \n"
       " |  __  | |    |  __| |  _ <| |   | |  | || | | . ` | \n"
       " | |  | | |____| |____| |_) | |___| |__| || |_| |\\  | \n"
       " |_|  |_|______|______|____/ \\_____\\____/_____|_| \\_| \n";

const std::string nonWindowsAsciiArt = 
      "\n                                                                            \n"
        "██╗  ██╗██╗     ███████╗██████╗  ██████╗ ██████╗ ██╗███╗   ██╗\n"
        "██║  ██║██║     ██╔════╝██╔══██╗██╔════╝██╔═══██╗██║████╗  ██║\n"
        "███████║██║     █████╗  ██████╔╝██║     ██║   ██║██║██╔██╗ ██║\n"
        "██╔══██║██║     ██╔══╝  ██╔══██╗██║     ██║   ██║██║██║╚██╗██║\n"
        "██║  ██║███████╗███████╗██████╔╝╚██████╗╚██████╔╝██║██║ ╚████║\n"
        "╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝\n";

/* Windows has some characters it won't display in a terminal. If your ascii
   art works fine on Windows and Linux terminals, just replace 'asciiArt' with
   the art itself, and remove these two #ifdefs and above ascii arts */
#ifdef _WIN32
const std::string asciiArt = windowsAsciiArt;
#else
const std::string asciiArt = nonWindowsAsciiArt;
#endif
