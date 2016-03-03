When running this container, you will be able to load the skyline webpage at port 1500.

NOTE: I haven't yet confirmed that horizon and the analyzer are working, other than that their logs don't complain about anything.  (except about starving for data)

Build and run with:

    # Install Docker, using instructions at http://docker.io/gettingstarted/
    
    # download Docker build files
    git clone https://github.com/carver/docker-skyline
    cd docker-skyline
    
    # build
    docker build -t="carver/skyline" .
    
    # run
    docker run --name skyline -d  -p :1500:1500 -p :2025:2025/udp carver/skyline
    
    # behold
    curl localhost:1500

    ## workaround when missing graphite:
    docker exec -i -t xxxxxx bash
    vi /opt/skyline/src/settings.py
    remove localhost for graphite
    kill analyzer and restart it
    cd /opt/skyline/bin
    ./analyzer.d start

If you want to show the log output at the terminal when running, omit the -d, like:

    docker run carver/skyline
