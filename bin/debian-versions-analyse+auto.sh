#!/bin/sh

#TOTAL
P_TOTAL=`aptitude search "?installed"|wc -l`
echo "TOTAL PACKAGES INSTALLED:" $P_TOTAL"\n"

#stable
P_STABLE=`aptitude search '?any-version(?installed ?archive(^stable$))'|wc -l`
echo "Stable:      " $P_STABLE
 
#backports
P_BACKPORTS=`aptitude search '?any-version(?installed !?archive(^stable$) ?archive(backports))'|wc -l`
echo "Backported:  " $P_BACKPORTS

#testing
P_TESTING=`aptitude search '?any-version(?installed !?archive(^stable$) !?archive(backports) ?archive(testing))'|wc -l`
echo "Testing:     " $P_TESTING

#unstable
P_UNSTABLE=`aptitude search '?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) ?archive(unstable))'|wc -l`
echo "Unstable:    " $P_UNSTABLE

#experimental
P_EXPERIMENTAL=`aptitude search '?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) ?archive(experimental))'|wc -l`
echo "Experimental:" $P_EXPERIMENTAL
 
#other
P_OTHER=`aptitude search '?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) !?archive(experimental))'|wc -l`
echo "Other:       " $P_OTHER"\n"

#check if total = sum of parts
[ $(($P_STABLE+$P_BACKPORTS+$P_TESTING+$P_UNSTABLE+$P_EXPERIMENTAL+$P_OTHER)) -eq $P_TOTAL ] && echo "Checksum:     ok" || echo "Checksum:     error"
