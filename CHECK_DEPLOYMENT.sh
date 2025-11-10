#!/bin/bash

# MEMOGEN Deployment Checker
# Verifies GitHub Pages deployment status

echo "🔍 MEMOGEN GitHub Pages Deployment Checker"
echo "==========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check 1: Verify index.html exists
echo -n "📄 Checking index.html... "
if [ -f "index.html" ]; then
    SIZE=$(wc -c < index.html)
    echo -e "${GREEN}✓${NC} Found (${SIZE} bytes)"
else
    echo -e "${RED}✗${NC} Missing!"
    exit 1
fi

# Check 2: Verify .nojekyll exists
echo -n "🚫 Checking .nojekyll... "
if [ -f ".nojekyll" ]; then
    echo -e "${GREEN}✓${NC} Found"
else
    echo -e "${YELLOW}⚠${NC} Missing (creating...)"
    touch .nojekyll
fi

# Check 3: Check current branch
echo -n "🌿 Current branch... "
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}${BRANCH}${NC}"

# Check 4: Count vocabulary words
echo -n "📚 Vocabulary words... "
WORDS=$(grep -c "word:" index.html || echo "0")
echo -e "${BLUE}${WORDS}${NC} words"

# Check 5: Test local file structure
echo -n "🏗️  File structure... "
if grep -q "MEMOGEN" index.html && grep -q "vocabulary" index.html; then
    echo -e "${GREEN}✓${NC} Valid"
else
    echo -e "${RED}✗${NC} Invalid"
fi

echo ""
echo "🌐 Testing GitHub Pages URL..."
echo "================================"

# Check 6: Test GitHub Pages site
URL="https://umitkacar.github.io/MEMOGEN/"
echo -n "🔗 Checking ${URL}... "

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL" 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✓ LIVE!${NC} (HTTP $HTTP_CODE)"
    echo ""
    echo -e "${GREEN}🎉 SUCCESS!${NC} Your site is deployed and accessible!"
    echo "   Visit: $URL"
elif [ "$HTTP_CODE" = "404" ]; then
    echo -e "${RED}✗ NOT FOUND${NC} (HTTP $HTTP_CODE)"
    echo ""
    echo -e "${YELLOW}⚠️  GitHub Pages is NOT configured${NC}"
    echo ""
    echo "📋 REQUIRED ACTIONS:"
    echo "   1. Go to: https://github.com/umitkacar/MEMOGEN/settings/pages"
    echo "   2. Under 'Build and deployment':"
    echo "      - Source: Deploy from a branch"
    echo "      - Branch: ${BRANCH}"
    echo "      - Folder: / (root)"
    echo "   3. Click 'Save'"
    echo "   4. Wait 2-3 minutes for deployment"
    echo "   5. Run this script again to verify"
    echo ""
    echo "📖 For detailed instructions, see: GITHUB_PAGES_FIX.md"
else
    echo -e "${YELLOW}⚠ UNKNOWN${NC} (HTTP $HTTP_CODE)"
    echo ""
    echo "   This might mean:"
    echo "   - GitHub Pages is building (wait 2-3 minutes)"
    echo "   - Network issue (check connection)"
    echo "   - GitHub is having issues (check status.github.com)"
fi

echo ""
echo "📊 Summary"
echo "=========="
echo "Local files:  ${GREEN}Ready ✓${NC}"
echo "Branch:       ${BLUE}${BRANCH}${NC}"
echo "Vocabulary:   ${BLUE}${WORDS} words${NC}"
echo "GitHub Pages: $([ "$HTTP_CODE" = "200" ] && echo -e "${GREEN}Live ✓${NC}" || echo -e "${YELLOW}Needs Configuration ⏳${NC}")"
echo ""

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${BLUE}💡 TIP:${NC} After configuring GitHub Pages, changes take 2-3 minutes to deploy."
    exit 1
fi

exit 0
