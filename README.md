# 新README
改动了read_info.sh，使其能够自动git pull最新repo、将id填入toml、git push
另外可以在服务器上建个webhook，当仓库更新时自动拉取并deploy

## 食用方法
在root的安卓机下的termux
1. 首先拉取仓库
```bash
su
git clone git@github.com:evilCYH/fqnovel-api.git
```
2. 然后添加定时任务
```bash
echo "*/5 * * * * su -c 'sh /data/data/com.termux/files/home/fqnovel-api/read_info.sh' >> /data/data/com.termux/files/home/fq.log 2>&1" > mycron
crontab mycron
crond start
```


# 原README
补齐`wrangler.toml`中的两个id，\
id获取方法：安卓手机有root或者adb临时root后mt管理器root执行read_info.sh\
解密思路参考<https://rudo.foo/posts/fqnovel/>\
解压后目录内`npx wrangler deploy`部署到cloudflare，不会的自行搜索cf wrangler部署教程
![image](https://github.com/user-attachments/assets/23f856b1-8e28-4387-8087-81668ebe5cdd)
