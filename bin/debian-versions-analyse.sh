#!/bin/sh

#stable
echo -n "      Stable packages: "
aptitude search '!?automatic?any-version(?installed ?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) !?archive(experimental))'|wc -l
 
#backports
echo -n "  Backported packages: "
aptitude search '!?automatic?any-version(?installed !?archive(^stable$) ?archive(backports) !?archive(testing) !?archive(unstable) !?archive(experimental))'|wc -l

#testing
echo -n "     Testing packages: "
aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) ?archive(testing) !?archive(unstable) !?archive(experimental))'|wc -l

#unstable
echo -n "    Unstable packages: "
aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) ?archive(unstable) !?archive(experimental))'|wc -l

#experimental
echo -n "Experimental packages: "
aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) ?archive(experimental))'|wc -l
 
#other
echo -n "       Other packages: "
aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) !?archive(experimental))'|wc -l
