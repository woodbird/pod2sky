
add a container in skydns-rc.yaml:

    - name: pod2sky
          image: woodbird/pod2dns:0.5
          resources:
            # keep request = limit to keep this container in guaranteed class
            limits:
              cpu: 100m
              memory: 50Mi
            requests:
              cpu: 100m
              memory: 50Mi
          command:
          - /bin/bash
          - -c
          - /usr/bin/schedulePod2sky.sh
            --cluster_domain=test.com 
            --kube_master_url=http://192.168.1.200:8080
