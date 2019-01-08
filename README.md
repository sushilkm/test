# catalog-templates # stable-1

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [HSM Catalog](#hsm-catalog)
- [Catalog Templates Repository](#catalog-templates-repository)
- [Publishing SDL to release bucket](#publishing-sdl-to-release-bucket)
- [Process to publish SDLs](#process-to-publish-sdls)

# HSM Catalog
HSM Catalog is either an s3 bucket or github repository location which is used by HSM service to present list of available services that can be used/provisioned via HSM. Each HSM service deployment can be configured, to talk to a particular HSM catalog location.

In stackato 4.0 release the default catalog is served via stable-1 release bucket which is located at 
```
s3://helion-service-manager/release/catalog-templates/HCP-v1/stable-1
```
Both HCP and HSM are configured to talk to this bucket so all the services need to be published there so that
they show up in the HSM catalog.

# Publishing SDL to release bucket
stable-1 branch in catalog-templates repository is a mirror of that bucket.  We have established a process around
publishing service SDLs to the release bucket using stable-1 branch. This will allow service teams to control what sdl versions are available in the release bucket for their corresponding services, what are the upgrade paths for each of those versions and their dependencies etc.  And since the process is mostly automated it reduces manual labor and errors.

# Process to publish SDLs:
So next time you want to publish new SDL please follow this process:

1. Git clone catalog templates (note that you need stable-1 branch from that repo)
  ```
  git clone –b stable-1 git@github.com:hpcloud/catalog-templates
  ```

2. Each service has following directory structure
  ```
  catalog-templates
  └── services
      └── HPE
          └── <service name> # same as name in sdl.json
              └── <product_version> # same as product_version in sdl.json
                  └── <sdl_version> # same as sdl_version in sdl.json
                      └── config.json # This controls the upgrade path (sample)
                      └── sdl
                          └── sdl.json
  ```

3. When you need to add new SDL, go to the service specific directory for your service, make a new sdl_version directory and sdl directory under it and then add your sdl.json to it.

4. For adding IDL, it needs to go in
  ```
  catalog-templates
  └── instance-definition
      └── <service name> # same as name in sdl.json
          └── <product_version> # same as product_version in sdl.json
              └── <sdl_version> # same as sdl_version in sdl.json
                  └── instance.json
  ```

5. Then please submit a PR in catalog-templates repo against stable-1 branch with these changes/new files

6. Once you submit the PR, there is a concourse PR pipeline that runs against it and validates that new changes being submit comply with the required directory structure.

7. We are still working on making these checks full proof, and there might still be some corner cases which may not be be caught by these checks. So even if this gate passes we would like one human review on this, to make sure we are not polluting the release bucket, so please ping us in #hsm channel or via slack directly, to help get this reviewed before we merge it.

8. Once this patch merges, we have another concourse merge pipeline which will publish your change to the s3 bucket.
