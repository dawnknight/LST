function [ line ] = readline( filepath , linenum)

  fid = fopen(filepath, 'rt');

  if fid == -1

    disp 'open file error'

    return

  end

  count = 0;

  while(1)

    line = fgetl(fid);

    if ~ischar(line)

      fclose(fid);

      break

    end

    if count == linenum

      line = str2num(line);

      fclose(fid);

      break

    end

  count = count + 1;

  end

end