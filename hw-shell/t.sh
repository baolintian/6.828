ls > y
cat < y | sort | uniq | wc > y1
cat y1
rm y1
ls |  sort | uniq | wc
rm y
# wc 默认输出三个参数，分别是行数、单词数、字母数