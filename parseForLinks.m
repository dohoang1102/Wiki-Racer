function links = parseForLinks(input, checked)
   links = regexp(input,'/wiki/\w+["]','match');
   links = unique(regexprep(links, '"', ''));
   if (nargin == 2) 
       links = setdiff(links, checked); 
   end
   
   %links=links{cell2mat(regexp(links,'/wiki/[^H]+[^e]+[^l]+[^p]+.*'))};
   %links={links};
end