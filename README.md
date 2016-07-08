# Running the Container
	
	docker run -d -p 2003:2003/udp -p 2003:2003 -p 2004:2004 -p 7002:7002 -v <insert your directory here>:/data/graphite --name graphite gr4y/docker-graphite-carbon