# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
 require 'data1'

def get_link(t_url)
 if(t_url.index(/^\/|^.\//))
  t_url = $tg_url+"/"+t_url
 end
 puts t_url
 page = data1::HTML(open(t_url)) 
 after_link = Array.new()
 before_link = page.css("a").map{|link|link['href']}  #가공 전
 before_link = before_link.uniq  # 중복제거
 for index in before_link # Loop!
   if(index == nil)
    break;
   end
   if(index.index(/:|^#|^&|^\/\//) != nil)
     if(index.index(t_url) != nil)
       after_link.push(index)
     end
   else
     after_link.push(index)
   end
 end
 return after_link
end

def go_link(crawl_link,links)
 temp_link = links.pop()
 links = links+get_link(temp_link)
 crawl_link.push(temp_link)
 links = links-crawl_link
 puts temp_link
 if(links.size)
  go_link(crawl_link,links)
 else
  return 0
 end
end

t_url = "file:///G:/%EB%8C%80%ED%95%99%EC%9B%90/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8/%ED%98%84%EB%8C%80/data1.htm"   # -> 나중에 argv로 변경하세요.
$tg_url = t_url
crawl_link = Array.new()
links = get_link(t_url)
go_link(crawl_link,links)
