#ifndef _RE2C_PARSE_PARSER_
#define _RE2C_PARSE_PARSER_

#include <map>
#include <string>

#include "src/codegen/output.h"
#include "src/ir/regexp/regexp.h"
#include "src/parse/scanner.h"

namespace re2c
{

extern void parse(Scanner &, Output &);
extern void parse_cleanup();

typedef std::set<std::string> CondList;
typedef std::vector<const RegExpRule*> Spec;
typedef std::map<std::string, Spec> SpecMap;
typedef std::map<std::string, std::pair<uint32_t, std::string> > SetupMap;
typedef std::map<std::string, const Code *> DefaultMap;
typedef std::map<std::string, const RegExp *> symbol_table_t;

} // namespace re2c

#endif // _RE2C_PARSE_PARSER_
