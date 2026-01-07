server {
    listen ${LISTEN_PORT};
    server_name ${SERVER_NAME};

    client_max_body_size 50m;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log warn;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_vary on;

    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location /static/ {
        alias /vol/static/;
        expires 30d;
        add_header Cache-Control "public, max-age=2592000, immutable";
    }

    location /media/ {
        alias /vol/media/;
        expires 7d;
        add_header Cache-Control "public, max-age=604800";
    }

    location /api/ {
        include /etc/nginx/uwsgi_params;
        uwsgi_pass ${APP_HOST}:${APP_PORT};
        uwsgi_read_timeout 60s;
        uwsgi_send_timeout 60s;
    }

    location /admin/ {
        include /etc/nginx/uwsgi_params;
        uwsgi_pass ${APP_HOST}:${APP_PORT};
        uwsgi_read_timeout 60s;
        uwsgi_send_timeout 60s;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;

        try_files $uri $uri/ /index.html;

        expires 1h;
        add_header Cache-Control "public, max-age=3600";
    }
}
