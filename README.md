# docker_ubuntu_desktop
 Docker file to create the ubuntu desktop for running on mac<br/>
 The docker image can be found the followign in the docker hub:<br/>
 <pre>bennyplo1218/ubuntu-desktop-mac-m1</pre>
 <p>Hence, the docker file: <i>Dockerfile</i> consists the instructions to build the image</p>
 <ul><li>Build the docker image
 To build the docker image:
 <pre><i>$./builddocker</i></pre></li>
 <li>To run teh docker image</li>
 <pre><i>$./rundocker</li>
 <li>To pull the rolling (latest) version (ubuntu v22.04) from the docker hub:<pre><i>$./pull_rolling</i></pre>
 or <pre><i>$./pull_latest</i></pre></li>
 <li>To run the rolling (latest) version (from the image pull from the hub):
<pre><i>$./run_rolling</i></pre></li>
or
<pre><i>$./run_latest</i></pre></li>
 <li>To pull the focal version (ubuntu v20.04) from the docker hub:
 <pre><i>$./pull_focal</i></pre></li>
 <li>To run the focal version (from the image pull from the hub):
 <pre><i>$./run_focal</i></pre></li>
 <li>To commit the docker container (for pushing onto the Docker hub)
 <pre><i>$./commitdocker</i></pre></li>
 <li>To push the docker image onto the Docker hub
 <pre><i>$./pushdocker</i></pre></li>
</ul> 
