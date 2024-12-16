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

for i, line in enumerate(io.open("games-knowledge-base\\rules.md", "r").readlines()):
    if line.startswith('#') or line.strip() == "":
        continue
    from_facts = line.split("->")[0].strip().split(";")
    to_fact = line.split("->")[1].strip()
    s = f"\n(defrule rule{i}"
    c=1
    for fact_index in from_facts:  
        s += f"\n(fact (name \"{facts[fact_index.strip()]}\") (confidence ?c{c}))"
        c+=1
    s += f"\n(not (exists (fact (name \"{facts[to_fact.strip()]}\"))))"
    s += "\n=>"
    s += f"\n(bind ?minConf (min"
    c=1
    for fact_index in from_facts:
        s += f" ?c{c}"
        c+=1
    s+=f"))"

    s+=f"\n(bind ?newConf (* ?minConf ?*confidence-rule{i}*))"
    s += f"\n(assert (fact (name \"{facts[to_fact.strip()]}\") (confidence ?newConf)))"
    s += f"\n(assert (sendmessage \"{str.join(", ", [facts[ind.strip()] for ind in from_facts])} -> {facts[to_fact]}\" ?newConf)))"
    out.write(s)

print("ye")
