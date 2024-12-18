import io
out = open("facts.clp", "w+", encoding='utf-8')

facts = {}

out.write("\n(deffacts possible-facts")
for line in io.open("games-knowledge-base\\facts.md", "r", encoding='utf-8').readlines():
    if line.startswith('#') or line.strip() == "":
        continue
    fact_index = line.split(":")[0].strip()
    fact_name = line.split(":")[1].strip()
    facts[fact_index] = fact_name
    out.write(f"\n(possible-fact (name \"{fact_name}\"))")
out.write("\n)")

for i, line in enumerate(io.open("games-knowledge-base\\rules.md", "r").readlines()):
    if line.startswith('#') or line.strip() == "":
        continue
    from_facts = line.split("->")[0].strip().split(";")
    to_fact = line.split("->")[1].strip()
    s = f"\n(defglobal ?*confidence-rule{i}* = 0.9)"
    out.write(s)

out.write("\n")

out.write(f"(deffacts facts")
for line in io.open("games-knowledge-base\\facts.md", "r", encoding='utf-8').readlines():
    if line.startswith('#') or line.strip() == "":
        continue
    fact_index = line.split(":")[0].strip()
    fact_name = line.split(":")[1].strip()
    facts[fact_index] = fact_name
    s = f"\n(fact (name \"{fact_name}\") (confidence 0.0))"
    out.write(s)

out.write(")\n")

out.write("(deffacts tokens")

for i, line in enumerate(io.open("games-knowledge-base\\rules.md", "r").readlines()):
    if line.startswith('#') or line.strip() == "":
        continue
    from_facts = line.split("->")[0].strip().split(";")
    to_fact = line.split("->")[1].strip()
    s = f"\n(token (name \"rule{i}\"))"
    out.write(s)

out.write(")\n")

for i, line in enumerate(io.open("games-knowledge-base\\rules.md", "r").readlines()):
    if line.startswith('#') or line.strip() == "":
        continue
    from_facts = line.split("->")[0].strip().split(";")
    to_fact = line.split("->")[1].strip()
    s = f"\n(defrule rule{i}"
    c=1
    for fact_index in from_facts:  
        s += f"\n(fact (name \"{facts[fact_index.strip()]}\") (confidence ?c{c}))"
        s += f"\n(test (> (abs ?c{c}) 0.4))"
        c+=1
    
    #s += f"\n(not (exists (fact (name \"{facts[to_fact.strip()]}\"))))"
    s += f"\n?f <- (fact (name \"{facts[to_fact.strip()]}\") (confidence ?cf_))"
    s += f"\n?tk <- (token (name \"rule{i}\"))"
    s += "\n=>"
    s += f"\n(retract ?tk)"
    s += f"\n(bind ?minConf (min"
    c=1
    for fact_index in from_facts:
        s += f" ?c{c}"
        c+=1
    s += f"))"

    s += f"\n(bind ?newConf (combine (* ?minConf ?*confidence-rule{i}*) ?cf_))"
    s += f"\n(modify ?f (confidence ?newConf))"
    s += f"\n(assert (fact (name \"{facts[to_fact.strip()]}\") (confidence ?newConf)))"
    s += f"\n(assert (sendmessage \"{str.join(", ", [facts[ind.strip()] for ind in from_facts])} -> {facts[to_fact]}\" ?newConf)))"
    out.write(s)

print("ye")
