Problem: Docker image failed to build due to outdated base image and missing dependencies. 
Fix applied: Updated Dockerfile to a compatible base image, added required system dependencies, and upgraded outdated package versions. This build now succeeds when running 'docker -t myapp .'.
Reproduction steps (original): 
1. Run 'docker build -t myapp .'
2. Build failed with missing/incompatible dependencies. 
Status: Verified locally after chnages.
