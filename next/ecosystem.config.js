module.exports = {
    apps: [
      {
        name: 'next-drupal',
        script: 'yarn',
        args: 'dev',
        cwd: './', // Base directory for the application
        watch: true,
        env: {
          NODE_ENV: 'development'
        },
        wait_ready: true,
        listen_timeout: 5000 // 5 seconds
      }
    ]
  };