congruent = find(d.subjects.testdata.allcodes(4,:) == 1); % congruent
incongruent = find(d.subjects.testdata.allcodes(4,:) == 2); % incongruent
size = find(d.subjects.testdata.allcodes(5,:) == 1); % size
colour = find(d.subjects.testdata.allcodes(5,:) == 2); % colour

sizetrials = d.subjects.testdata.allcodes(:,size);
congruent = find(sizetrials(4,:) == 1); % congruent
incongruent = find(sizetrials(4,:) == 2); % incongruent
csizetrials = sizetrials(:,congruent);
isizetrials = sizetrials(:,incongruent);
sizeres = [mean(csizetrials(1,:)),mean(isizetrials(1,:))]

colourtrials = d.subjects.testdata.allcodes(:,colour);
congruent = find(colourtrials(4,:) == 1); % congruent
incongruent = find(colourtrials(4,:) == 2); % incongruent
ccolourtrials = colourtrials(:,congruent);
icolourtrials = colourtrials(:,incongruent);
colourres = [mean(ccolourtrials(1,:)),mean(icolourtrials(1,:))]