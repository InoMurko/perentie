defmodule Perentie.Serializer do
	def encode({time, {:trace, _pid, _, {mod, function, _args}, {:erl_eval, :do_apply, _}}}) do
  		:skip
  	end

	def encode({time, {:trace, _pid, _, {mod, function, args}, result}}) do
  		%{	#:time => :calendar.now_to_local_time(time),
  			:tracing => 
  				Atom.to_string(mod) <> " " <> Atom.to_string(function) <> " " 
          <> :io_lib.write(args) 
            |> List.flatten 
            |> to_string,
  			:result => 
          :io_lib.write(result) |> List.flatten |> to_string
  		}
  	end

  	def encode([_head | _tail] = nodes) do
  		fun = fn(x, acc) -> 
  			splitted = String.split(Atom.to_string(x), "_")
  			case length(splitted) do
  				2 -> 
  					[node, cookie] = splitted
  					[%{:name => node, :cookie => cookie} | acc]
  				_ -> 
  					name0 = :lists.droplast(splitted)
  					name = Enum.reduce(Enum.reverse(name0), 
  						fn (x, acc) -> 
  								x <> "_" <> acc 
  						end)
  					cookie = List.last(splitted)
  					[%{:name => name, :cookie => cookie} | acc]
  			end
  		end
		%{:nodes => Enum.reduce(nodes,[], fun)}
	end
end