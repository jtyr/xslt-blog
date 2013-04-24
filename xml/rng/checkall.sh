#!/bin/sh

echo "### Check ArticleList.xml:"
xmllint --noout --relaxng ./ArticleList.rng ../ArticleList.xml
echo "### Check CategoryList.xml:"
xmllint --noout --relaxng ./CategoryList.rng ../CategoryList.xml
echo "### Check LangList.xml:"
xmllint --noout --relaxng ./LangList.rng ../LangList.xml
echo "### Check all Lang-*.xml:"
ls -1 ../lang/*.xml | awk '{system("xmllint --noout --relaxng ./Lang.rng ../lang/"$0)}'
echo "### Check all Article-*.xml:"
ls -1 ../articles/*.xml | awk '{system("xmllint --noout --relaxng ./Article.rng ../articles/"$0)}'
