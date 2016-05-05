
在skydns-rc.yaml中添加container:

    - name: pod2dns
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
          - /usr/bin/schedulePod2dns.sh
            --cluster_domain=test.com 
            --kube_master_url=http://192.168.1.200:8080
