#!/bin/bash
set -ev

# Ensure /usr/sbin/bird{,6} are in the path.
PATH=$PATH:/usr/sbin

if [ "${1}" == '-d' -o "${1}" == '--debug' ]; then
    arguments='debug'
fi

routers='nikhef-1.router.netone.nl'

# generate peer configs
./peering_filters "${arguments}"

for router in ${routers}; do
    rm -rf /opt/router-staging/${router}
    mkdir -p /opt/router-staging/${router}

    ./gentool -y vars/generic.yml -t templates/envvars.j2 -o /opt/router-staging/${router}/envvars
    ./gentool -y vars/generic.yml vars/${router}.yml -t templates/ebgp_state.j2 -o /opt/router-staging/${router}/ebgp_state.conf

    ./gentool -4 -y vars/generic.yml vars/${router}.yml -t templates/header.j2 -o /opt/router-staging/${router}/header-ipv4.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml -t templates/header.j2 -o /opt/router-staging/${router}/header-ipv6.conf
#    ./gentool -y vars/generic.yml vars/${router}.yml -t templates/bfd.j2 -o /opt/router-staging/${router}/bfd.conf
#    ./gentool -y vars/generic.yml vars/${router}.yml -t templates/ospf.j2 -o /opt/router-staging/${router}/ospf.conf

    ./gentool -4 -y vars/generic.yml vars/${router}.yml -t templates/ibgp.j2 -o /opt/router-staging/${router}/ibgp-ipv4.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml -t templates/ibgp.j2 -o /opt/router-staging/${router}/ibgp-ipv6.conf

    ./gentool -y vars/generic.yml vars/${router}.yml -t templates/interfaces.j2 -o /opt/router-staging/${router}/interfaces.conf

    ./gentool -y vars/generic.yml vars/${router}.yml -t templates/generic_filters.j2 -o /opt/router-staging/${router}/generic_filters.conf

    ./gentool -4 -y vars/generic.yml vars/${router}.yml -t templates/afi_specific_filters.j2 -o /opt/router-staging/${router}/ipv4_filters.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml -t templates/afi_specific_filters.j2 -o /opt/router-staging/${router}/ipv6_filters.conf

#    ./gentool -4 -y vars/generic.yml vars/${router}.yml vars/members_bgp.yml -t templates/members_bgp.j2 -o /opt/router-staging/${router}/members_bgp-ipv4.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml vars/members_bgp.yml -t templates/members_bgp.j2 -o /opt/router-staging/${router}/members_bgp-ipv6.conf

    ./gentool -4 -y vars/generic.yml vars/${router}.yml vars/transit.yml -t templates/transit.j2 -o /opt/router-staging/${router}/transit-ipv4.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml vars/transit.yml -t templates/transit.j2 -o /opt/router-staging/${router}/transit-ipv6.conf

#    ./gentool -4 -y vars/generic.yml vars/${router}.yml vars/scrubbers.yml -t templates/scrubbers.j2 -o /opt/router-staging/${router}/scrubber-ipv4.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml vars/scrubbers.yml -t templates/scrubbers.j2 -o /opt/router-staging/${router}/scrubber-ipv6.conf
#    ./gentool -4 -y vars/generic.yml vars/${router}.yml vars/scrubbers.yml -t templates/via_scrubbers_afi.j2 -o /opt/router-staging/${router}/via_scrubbers_ipv4.conf
#    ./gentool -6 -y vars/generic.yml vars/${router}.yml vars/scrubbers.yml -t templates/via_scrubbers_afi.j2 -o /opt/router-staging/${router}/via_scrubbers_ipv6.conf

    ./gentool -4 -t templates/static_routes.j2 -y vars/statics-nikhef.yml -o /opt/router-staging/${router}/static_routes-ipv4.conf
#    ./gentool -6 -t templates/static_routes.j2 -y vars/statics-nikhef.yml -o /opt/router-staging/${router}/static_routes-ipv6.conf

    rsync -av blobs/${router}/ /opt/router-staging/${router}/
    rsync -av /opt/routefilters/rpki/ /opt/router-staging/${router}/rpki/

    rsync -av --delete /opt/routefilters/*bird* /opt/router-staging/${router}/peerings/
    rsync -av --delete /opt/routefilters/${router}.ipv4.config /opt/router-staging/${router}/peerings/peers.ipv4.conf
#    rsync -av --delete /opt/routefilters/${router}.ipv6.config /opt/router-staging/${router}/peerings/peers.ipv6.conf

    TZ=Etc/UTC date '+# Created: %a, %d %b %Y %T %z' >>  /opt/router-staging/${router}/bird.conf
#    TZ=Etc/UTC date '+# Created: %a, %d %b %Y %T %z' >>  /opt/router-staging/${router}/bird6.conf

done

if [ "${1}" == "push" ]; then

	# sync config to nikhef-1.router
	eval $(ssh-agent -t 600)
	ssh-add ~/.ssh/id_rsa_nikhef1

    for router in ${routers}; do
        echo "Checking for ${router}"
        bird -c /opt/router-staging/${router}/bird.conf -p
#        bird6 -c /opt/router-staging/${router}/bird6.conf -p
    done

    for router in ${routers}; do
        echo uploading for ${router}
        rsync -avH --delete /opt/router-staging/${router}/ root@${router}:/etc/bird/
        ssh root@${router} 'chown -R root: /etc/bird; /usr/sbin/birdc configure; /usr/sbin/birdc6 configure' | sed "s/^/${router}: /"
    done

    # kill ssh-agent
    eval $(ssh-agent -k)

    # update RIPE if new peers are added
#    php /opt/coloclue/update-as8283-ripe.php

	# kill ssh-agent
	eval $(ssh-agent -k)
elif [ "${1}" == "check" ]; then

    for router in ${routers}; do
        echo "Checking for ${router}"
        bird -c /opt/router-staging/${router}/bird.conf -p
#        bird6 -c /opt/router-staging/${router}/bird6.conf -p
    done
else
    echo "Command '${1}' not supported" 1>&2
	exit 1
fi
